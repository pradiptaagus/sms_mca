Get message and send message with python and Pushbullet API. 

Send request to access database and send query result by sms.

For more information about Pushbullet API, please visit https://docs.pushbullet.com/

--------------------------------------------------------------------------------------
API Token can get from pushbullet account
source_user_iden can get from running https://api.pushbullet.com/v2/me with token. See Pushbullet documentation

Step to use

1. Change api_token in both of my_websocket.py and reply_engine.py. Also change source_user_iden in my_websocket.py

2. Create database with name sms_mca

3. Export sms_mca sql to database

4. Run both of my_websocket.py and reply_engine.py

5. Enjoy

