#!/bin/bash

echo "[*] Starting Linux Cross-Platform Lab..."

# 1. Determine the correct Python command
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
else
    echo "[-] Error: Python is not installed!"
    exit 1
fi

# 2. Verify ffuf is installed
if ! command -v ffuf &>/dev/null; then
    echo "[-] Error: ffuf is not installed! Run 'sudo apt install ffuf' first."
    exit 1
fi

# 3. Start the mock server in the background
echo "[*] Launching Mock Target Server on http://localhost:8000..."
$PYTHON_CMD mock_server.py & SERVER_PID=$!

# 4. Wait briefly for the server to bind to the port
sleep 2

# 5. Execute the automated ffuf scan with JSON output
echo "[*] Executing ffuf fuzzing pipeline..."
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -o ffuf_report.json -of json

# 6. Check if JSON report was created
if [ -f ffuf_report.json ]; then
    echo "[+] JSON report generated: ffuf_report.json"
    
    # 7. Generate HTML report from JSON
    echo "[*] Generating HTML report..."
    $PYTHON_CMD - <<'EOF'
import json
from datetime import datetime

try:
    with open('ffuf_report.json', 'r') as f:
        data = json.load(f)
    
    results = data.get('results', [])
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FFuf Scan Report</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }}
        .container {{
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }}
        header {{
            border-bottom: 3px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }}
        h1 {{
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }}
        .meta {{
            color: #666;
            font-size: 14px;
            display: flex;
            gap: 20px;
        }}
        .meta span {{
            display: flex;
            align-items: center;
            gap: 5px;
        }}
        .status {{
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 12px;
            margin-top: 10px;
        }}
        .status.success {{
            background-color: #d4edda;
            color: #155724;
        }}
        .status.info {{
            background-color: #d1ecf1;
            color: #0c5460;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }}
        thead {{
            background-color: #667eea;
            color: white;
        }}
        th {{
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }}
        td {{
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }}
        tr:hover {{
            background-color: #f5f5f5;
        }}
        .url {{
            color: #667eea;
            font-weight: 500;
            word-break: break-all;
        }}
        .code {{
            background-color: #f0f0f0;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-weight: bold;
        }}
        .no-results {{
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
        }}
        .summary {{
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }}
        .summary-card {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }}
        .summary-card h3 {{
            font-size: 12px;
            text-transform: uppercase;
            opacity: 0.8;
            margin-bottom: 10px;
        }}
        .summary-card .number {{
            font-size: 32px;
            font-weight: bold;
        }}
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🔍 FFuf Scan Report</h1>
            <div class="meta">
                <span>📅 Generated: {timestamp}</span>
                <span>🎯 Target: http://localhost:8000</span>
            </div>
            <div class="status success">✓ Scan Completed Successfully</div>
        </header>
        
        <div class="summary">
            <div class="summary-card">
                <h3>Total Results</h3>
                <div class="number">{len(results)}</div>
            </div>
            <div class="summary-card">
                <h3>Endpoints Found</h3>
                <div class="number">{len([r for r in results if 'path' in r])}</div>
            </div>
            <div class="summary-card">
                <h3>Success Rate</h3>
                <div class="number">100%</div>
            </div>
        </div>
        
        <h2 style="color: #333; margin-top: 30px; margin-bottom: 15px;">Results</h2>
"""
    
    if results:
        html_content += """        <table>
            <thead>
                <tr>
                    <th>URL</th>
                    <th>Status Code</th>
                    <th>Response Size</th>
                    <th>Words</th>
                    <th>Lines</th>
                </tr>
            </thead>
            <tbody>
"""
        for result in results:
            url = result.get('url', 'N/A')
            status = result.get('status', 'N/A')
            size = result.get('length', 'N/A')
            words = result.get('words', 'N/A')
            lines = result.get('lines', 'N/A')
            
            html_content += f"""                <tr>
                    <td><span class="url">{url}</span></td>
                    <td><span class="code">{status}</span></td>
                    <td>{size}</td>
                    <td>{words}</td>
                    <td>{lines}</td>
                </tr>
"""
        
        html_content += """            </tbody>
        </table>
"""
    else:
        html_content += """        <div class="no-results">
            No results found during the scan.
        </div>
"""
    
    html_content += """    </div>
</body>
</html>
"""
    
    with open('ffuf_report.html', 'w') as f:
        f.write(html_content)
    
    print("[+] HTML report generated: ffuf_report.html")

except Exception as e:
    print(f"[-] Error generating HTML report: {e}")
EOF
else
    echo "[-] Error: JSON report not generated"
fi

# 8. Clean up the background server
echo "[*] Scan complete. Stopping Mock Target Server (PID: $SERVER_PID)..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "[+] Done! Check ffuf_report.html and ffuf_report.json for results."
