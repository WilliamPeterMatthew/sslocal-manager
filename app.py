import os
import subprocess
from flask import Flask, render_template, request, redirect

app = Flask(__name__)

def get_status():
    try:
        with open('/var/run/ss-local.pid', 'r') as f:
            pid = f.read().strip()
        
        # 检查进程是否存在
        os.kill(int(pid), 0)
        return (True, pid)
    except (FileNotFoundError, ValueError, ProcessLookupError):
        return (False, None)

@app.route('/')
def index():
    status = get_status()
    return render_template('index.html', 
                          running=status[0],
                          pid=status[1])

@app.route('/status')
def status():
    running, pid = get_status()
    if running:
        return f"Running With PID {pid}", 200
    return "Not Running", 502

@app.route('/action', methods=['POST'])
def action():
    running, pid = get_status()
    
    if running:
        subprocess.run(["kill", pid])
        os.remove('/var/run/ss-local.pid')
    else:
        subprocess.Popen([
            "ss-local",
            "-c", "/.ssconfig.json",
            "-f", "/var/run/ss-local.pid"
        ])
    
    return redirect('/')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
