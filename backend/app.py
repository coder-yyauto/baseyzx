from flask import Flask
from flask_cors import CORS
from config import Config
import os

# 加载.env文件
from dotenv import load_dotenv
load_dotenv()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # 启用CORS
    CORS(app)
    
    # 注册蓝图
    from views import main_bp
    app.register_blueprint(main_bp)
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(
        host='0.0.0.0',
        port=int(os.environ.get('PORT', 5000)),
        debug=Config.DEBUG
    )