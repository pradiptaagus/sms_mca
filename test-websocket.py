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
        print("\n")
    
    if messageType == "sms_changed":
        messageBody = result.get("push",{}).get("notifications")
        messageBody = messageBody[0].get("body")
        sender = result.get("push",{}).get("notifications")
        sender = sender[0].get("title")

        print("type: " + str(messageType))
        print("application_name: " + str(applicationName))
        print("sender: " + str(sender))
        print("message: " + str(messageBody))
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