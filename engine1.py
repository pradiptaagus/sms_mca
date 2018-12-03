import json
import requests

api_token = 'o.3jlS0nO1oAQ5bO3Nq7uo6jS899W9fFM4'
api_base_url = 'https://api.pushbullet.com/v2/'
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer {0}'.format(api_token)}

def get_account_info():
    api_url = api_base_url + 'users/me'
    response = requests.get(api_url, headers=headers)
    print(response)

    if response.status_code == 200:
        return json.loads(response.content.decode('utf-8'))
    else:
        return None

def send_message(phoneNumber):
    api_url = api_base_url + 'ephemerals'
    
    data = {
    "push": {
        "conversation_iden": str(phoneNumber),
        "message": "Hello!",
        "package_name": "com.pushbullet.android",
        "source_user_iden": "ujCVuSMe5ym",
        "target_device_iden": "ujCVuSMe5ymsjAiVsKnSTs",
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

def get_devices():
    api_url = api_base_url + 'devices'
    response = requests.get(api_url, headers=headers)
    print(response)

    if response.status_code == 200:
        devices = json.loads(response.content.decode('utf-8'))
        return devices['devices']
    else:
        return None

def get_chats():
    api_url = api_base_url + 'chats'
    response = requests.get(api_url, headers=headers)
    print(response)

    if response.status_code == 200:
        return json.loads(response.content.decode('utf-8'))
    else:
        return None



def main():

    # --------- get accrount info -------------#
    account_info = get_account_info()

    if account_info is not None:
        print("your information:")
        for i, j in account_info.items():
            print('{0}:{1}'.format(i,j))
    else:
        print('[!] Request failed')


    # --------- send message ------------------#
    # send = send_message('081246283634')
    # if send is not None:
    #     print("success")
    #     for i, j in send.items():
    #         print('{0}:{1}'.format(i,j))
    # else:
    #     print('[!] Request failed')


    #---------- get devices -------------------#
    # devices = get_devices()
    # if devices is not None:
    #     for i in devices:
    #         print('{0}'.format(i))
    # else:
    #     print('[!] Request failed')

    #---------- get chats ---------------------#

# run main function
main()