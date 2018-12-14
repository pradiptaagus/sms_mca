import pymysql
import json
import requests
import time

from pymysql import Error

api_token = 'o.3jlS0nO1oAQ5bO3Nq7uo6jS899W9fFM4'
api_base_url = 'https://api.pushbullet.com/v2/'
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer {0}'.format(api_token)}


def getOutbox():
    result = ""

    try:
        query = "SELECT * FROM outbox WHERE status = 0;"
        cur.execute(query)
        result = cur.fetchall()

    except Error as e:
        error = "DataError: " + str(e)
        print(error)

    return result


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


def updateStatus(message_id):
    try:
        query = "UPDATE outbox SET status = 1 WHERE outbox_id = %s;" % message_id
        cur.execute(query)
        db.commit()
        print("status updated!")

    except Error as e:
        error = "DataError: " + str(e)
        print(error)


def main():
    try:
        all_data = getOutbox()
        print(all_data)

        if all_data == "":
            print("Failed to connect to database!")
        else:
            for i in all_data:
                if i[5] == 0:
                    message_id = i[0]
                    target_device_iden = i[1]
                    source_user_iden = i[2]
                    conversation_iden = i[3]
                    message = i[4]

                    print("Send message:")
                    print("target_device_iden: " + target_device_iden)
                    print("source_user_iden: " + source_user_iden)
                    print("conversation_iden: " + conversation_iden)
                    print("message: " + message)
                    print("\n")

                    reply(target_device_iden, source_user_iden, conversation_iden, message)

                    updateStatus(message_id)
    except pymysql.DatabaseError as e:
        print(e)


while True:
    db = ""
    try:
        db = pymysql.connect("localhost", "root", "", "sms_mca")
        cur = db.cursor()
        main()
        print("status: nop \n")
        db.rollback()
    except pymysql.DatabaseError as e:
        print(e)
    print("\n")
    time.sleep(5)
