import pymysql
import json
import requests
import time

api_token = 'o.3jlS0nO1oAQ5bO3Nq7uo6jS899W9fFM4'
api_base_url = 'https://api.pushbullet.com/v2/'
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer {0}'.format(api_token)}

def getOutbox():
    result = ""
    
    try: 
        query = "SELECT * FROM outbox;"
        cur.execute(query)
        result = cur.fetchall()

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

def updateSatus(message_id):
    try:
        query = "UPDATE outbox SET status = 1 WHERE outbox_id = %s;" %(message_id)
        cur.execute(query)
        db.commit()
        print("status updated!")

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

def main():
    try: 
        db = pymysql.connect("localhost", "root", "", "sms_mca")
        cur = db.cursor()
        allData = getOutbox()
        
        if allData == "":
            print("Failed to conect to database!")
        else:
            for i in allData:
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

                    updateSatus(message_id)
        db.rollback()
    except pymysql.DatabaseError as e:
        print(e)

while True:
    try: 
        db = pymysql.connect("localhost", "root", "", "sms_mca")
        cur = db.cursor()
        main()
        print("status: nop \n")
    except pymysql.DatabaseError as e:
        print(e)
    
    print("\n")
    time.sleep(5)
    
    
    
    
    
