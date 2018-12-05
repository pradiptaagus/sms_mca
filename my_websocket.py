import datetime
import pymysql
import websocket
import json
try:
    import thread
except ImportError:
    import _thread as thread
import time

api_token = 'o.3jlS0nO1oAQ5bO3Nq7uo6jS899W9fFM4'
api_base_url = 'wss://stream.pushbullet.com/websocket/'


    

def on_message(ws, message):
    result = message = json.loads(message)
    messageType = result.get("push",{}).get("type")
    applicationName = result.get("push",{}).get("application_name") 

    if messageType == "mirror":
        messageBody = result.get("push",{}).get("body")
        
        messageTitle = result.get("push",{}).get("title")
        
        print("type: " + str(messageType))
        print("application_name: " + str(applicationName))
        print("title: " + str(messageTitle))
        print("message: " + str(messageBody))
    
    if messageType == "sms_changed":
        notifications = result.get("push",{}).get("notifications")

        if not notifications:
            # do nothing
            print()
        else:
            messageBody = notifications[0].get("body")
            
            sender = notifications[0].get("title")
            
            source_device_iden = result.get("push",{}).get("source_device_iden")
            
            timestamp = notifications[0].get("timestamp")
            readable_timestamp = datetime.datetime.fromtimestamp(timestamp)
            readable_timestamp = readable_timestamp.strftime('%Y-%m-%d %H:%M:%S')


            # insert response to database
            try:
                db = pymysql.connect("localhost", "root", "", "sms_mca")
                cur = db.cursor()
                
                query = "INSERT INTO inbox (source_device_iden, sender, message, status, inbox_time) VALUES('%s', '%s', '%s', 1, '%s');" %(source_device_iden, sender, messageBody, readable_timestamp)
                cur.execute(query)
                db.commit()

                print("type: " + str(messageType))
                print("source_device_iden: " + str(source_device_iden))
                print("sender: " + str(sender))
                print("message: " + str(messageBody))
                print("timestamp: " + str(readable_timestamp))
            
            except pymysql.DataError as e:
                error = "DataError: " + str(e)
                print(error)

            except pymysql.InternalError as e:
                error = "InternalError: " + str(e)
                print(error)
            
            except pymysql.IntegrityError as e:
                error = "IntegrityError: " + str(e)
                print(error)

            except pymysql.OperationalError as e:
                error = "OperationalError: " + str(e)
                print(error)

            except pymysql.NotSupportedError as e:
                error = "NotSupportedError: " + str(e)
                print(error)

            except pymysql.ProgrammingError as e:
                error = "ProgrammingError: " + str(e)
                print(error)

        print("\n")

    else:
        print("status: " + str(result["type"]))
        print("\n")

    
    # print(message)

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    def run(*args):
        while(True):
            time.sleep(1)
            # ws.send("Hello %d" % i)
        time.sleep(1)
        ws.close()
        print("thread terminating...")
    thread.start_new_thread(run, ())


if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(api_base_url + api_token,
                              on_message = on_message,
                              on_error = on_error,
                              on_close = on_close)
    ws.on_open = on_open
    ws.run_forever()
