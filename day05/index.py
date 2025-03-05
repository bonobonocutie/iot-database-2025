# 파이썬 웹앱(Flask)
## pip install Flask
from flask import Flask, render_template, request
import pymysql

# 변수 초기화
host = 'localhost' # or '127.0.0.1'
port = 3306
database = 'madang'
username = 'root'
password = '12345'

conflag = True # 접속상태

app = Flask(__name__) # 플라스크 웹앱 실행

conn = pymysql.connect(host=host, user= username, passwd = password, port=port, db=database)
cursor = conn.cursor()

@app.route('/') # routing decorator: 웹사이트 경로를 실행할 때 http://localhost:5000/
def index():
    query = ''' select bookid, bookname, publisher, price
                from Book'''
    res = cursor.execute(query)
    book_list = cursor.fetchall()
    # templates 폴더에 있는 html을 데이터와 연결해서 렌더링
    return render_template('booklist.html', book_list=book_list)

@app.route('/view') # http://localhost/localhost:5000/view?id=2
def getDetail():
    bookid = request.args.get('id')
    query = f''' select bookid, bookname, publisher, price
                from Book where bookid = '{bookid}' '''
    data = cursor.fetchall()
    return render_template('bookview.html', book=data)

if __name__ == '__main__':
    app.run('localhost')