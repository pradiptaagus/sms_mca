import datetime
import pymysql
import requests
import websocket
import json

from pymysql import Error

try:
    import thread
except ImportError:
    import _thread as thread
import time

api_token = <your_api_token>
api_base_url = 'wss://stream.pushbullet.com/websocket/'
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer {0}'.format(api_token)}
error = ""

def reply(target_device_iden, source_user_iden, conversation_iden, message):
    api_url = api_base_url + 'ephemerals'

    data = {
        "push": {
            "conversation_iden": str(conversation_iden),
            "message": str(message),
            "package_name": "com.pushbullet.android",
            "source_user_iden": str(source_user_iden),
            "target_device_iden": str(target_device_iden),
            "type": "messaging_extension_reply"
        },
        "type": "push"
    }
    response = requests.post(api_url, data=json.dumps(data), headers=headers)
    print(response)

    if response.status_code == 200:
        return json.loads(response.content.decode('utf-8'))
    else:
        return None

def on_message(ws, message):
    result = json.loads(message)
    print(message)
    messageType = result.get("push", {}).get("type")
    applicationName = result.get("push", {}).get("application_name")

    if messageType == "mirror":
        messageBody = result.get("push", {}).get("body")

        messageTitle = result.get("push", {}).get("title")

        print("type: " + str(messageType))
        print("application_name: " + str(applicationName))
        print("title: " + str(messageTitle))
        print("message: " + str(messageBody))

    if messageType == "sms_changed":
        notifications = result.get("push", {}).get("notifications")
        messageBody = ""
        sender = ""
        source_device_iden = ""
        readable_timestamp = ""

        if not notifications:
            # do nothing
            print()
        else:
            messageBody = notifications[0].get("body")
            print(messageBody)
            sender = notifications[0].get("title")
            source_device_iden = result.get("push", {}).get("source_device_iden")
            timestamp = notifications[0].get("timestamp")
            readable_timestamp = datetime.datetime.fromtimestamp(timestamp)
            readable_timestamp = readable_timestamp.strftime('%Y-%m-%d %H:%M:%S')

        # outbox params
        splitMessage = messageBody.split()
        print(splitMessage)
        outboxMessage = ""
        target_device_iden = source_device_iden
        source_user_iden = <your_source_user_iden>
        conversation_iden = sender
        status = 0

        try:
            db = pymysql.connect("localhost", "root", "", "sms_mca")
            cur = db.cursor()

            # determine message to send to client
            print(len(splitMessage))
            if splitMessage[0].lower() == "menu":
                cur.callproc("showMenu")
                result = cur.fetchall()
                index = 1
                for x in result:
                    temp = x
                    outboxMessage += (str(index) + ". " + temp[0] + "\n")
                    index += 1
                outboxMessage = "Silahkan balas dengan no menu\n" + outboxMessage

            elif splitMessage[0] == "1":
                outboxMessage = "Untuk melihat daftar mata kuliah berdasarkan semester, balas pesan ini" \
                                "dengan format SEMESTER <spasi> angka_semester. Contoh: SEMESTER 6"

            elif splitMessage[0] == "2":
                outboxMessage = "Untuk melihat rincian mata kuliah tertentu, balas pesan ini dengan format MATKUL " \
                                "<spasi> kode_matkul. Contoh: MATKUL TID030301"

            elif splitMessage[0] == "3":
                outboxMessage = "Untuk melihat nilai mata kuliah tertentu, balas pesan ini dengan format NILAI " \
                                "<spasi> kode_matkul <spasi> nim. Contoh: NILAI TID030301 1605551033"

            elif splitMessage[0].lower() == "semester":
                args = (splitMessage[1])
                cur.callproc("getCourseBySemester", args)
                result = cur.fetchall()
                if not result:
                    outboxMessage = "Daftar mata kuliah untuk semester %s tidak ditemukan." % (splitMessage[1])
                else:
                    index = 1
                    for i in result:
                        temp = i
                        outboxMessage += (
                            "{}. Kode = {}, nama = {}, konsentrasi = {}, sks = {}, semseter = {}\n".format(
                                index, temp[0], temp[1], temp[2], temp[3], temp[4]))
                        index += 1
                    outboxMessage = "Daftar mata kuliah untuk semester {}\n".format(args) + outboxMessage

            elif splitMessage[0].lower() == "matkul":
                args = (splitMessage[1])
                cur.callproc("getSpecificCourse", args)
                result = cur.fetchone()
                if not result:
                    outboxMessage = "Matakuliah dengan kode mata kuliah {} tidak ditemukan.".format(args)
                else:
                    outboxMessage = "Kode = {}, nama = {}, konsentrasi = {}, sks = {}, semester = {}".format(
                        result[0], result[1], result[2], result[3], result[4])

            elif splitMessage[0].lower() == "nilai":
                args = (splitMessage[1], splitMessage[2])
                cur.callproc("getSpecificGrade", args)
                result = cur.fetchone()
                if not result:
                    outboxMessage = "Nilai matakuliah dengan kode mata kuliah {} dan nim {} tidak ditemukan.".format(
                        splitMessage[1], splitMessage[2])
                else:
                    outboxMessage = "Kode = {}, nama = {}, nilai = {}".format(result[0], result[1], result[2])
            else:
                outboxMessage = "Halo, untuk melanjutkan balas dengan MENU"

            print(outboxMessage)

            # insert response into inbox table
            query = "INSERT INTO inbox (source_device_iden, sender, message, status, inbox_time) VALUES('%s', " \
                    "'%s', '%s', 1, '%s');" % (source_device_iden, sender, messageBody, readable_timestamp)
            cur.execute(query)
            db.commit()

            # insert into outbox
            query = "INSERT INTO outbox (target_device_iden, source_user_iden, conversation_iden, message, " \
                    "status) VALUES ('%s', '%s', '%s', '%s', %s);" % (target_device_iden, source_user_iden,
                                                                      conversation_iden, outboxMessage, status)
            cur.execute(query)
            db.commit()

            print("type: " + str(messageType))
            print("source_device_iden: " + str(source_device_iden))
            print("sender: " + str(sender))
            print("message: " + str(messageBody))
            print("timestamp: " + str(readable_timestamp))

            db.rollback()
        except Error as e:
            error = "DataError: " + str(e)
            print(error)

            if error:
                reply(target_device_iden, source_user_iden, conversation_iden, "Layanan sedang sibuk")

    else:
        print("status: " + str(result["type"]))
        print("message: " + str(result.get("push", {}).get("body")))
        print("\n")



def on_error(ws, error):
    print(error)


def on_close(ws):
    print("### closed ###")


def on_open(ws):
    def run(*args):
        while (True):
            time.sleep(1)
            # ws.send("Hello %d" % i)
        time.sleep(1)
        ws.close()
        print("thread terminating...")

    thread.start_new_thread(run, ())


if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(api_base_url + api_token,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()
