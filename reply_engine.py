import pymysql
import json
import requests

api_token = 'o.3jlS0nO1oAQ5bO3Nq7uo6jS899W9fFM4'
api_base_url = 'https://api.pushbullet.com/v2/'
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer {0}'.format(api_token)}

db = pymysql.connect("localhost", "root", "", "sms_mca")
cur = db.cursor()

def getOutbox():
    query = "SELECT * FROM outbox;"
    cur.execute(query)
    result = cur.fetchall()
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
    

def main():
    allData = getOutbox()
    for i in allData:
        if i[5] == 0:
            target_device_iden = i[1]
            source_user_iden = i[2]
            conversation_iden = i[3]
            message = i[4]

            print(target_device_iden + ", "+ source_user_iden + ", "+ conversation_iden + ", "+ message)

            reply(target_device_iden, source_user_iden, conversation_iden, message)

main()