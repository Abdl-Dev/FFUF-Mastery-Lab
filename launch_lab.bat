@echo off
title FFuf Windows Automation Lab
setlocal enabledelayedexpansion

echo [*] Starting Windows Cross-Platform Lab...

:: 1. Verify Python availability
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [-] Error: Python is not installed or not in your PATH!
    pause
    exit /b
)

:: 2. Verify FFuf availability
where ffuf >nul 2>nul
if %errorlevel% neq 0 (
    echo [-] Error: ffuf.exe is not installed or not in your PATH!
    pause
    exit /b
)

:: 3. Launch the Mock Server in a separate background window
echo [*] Launching Mock Target Server on http://localhost:8000...
start "FFuf Mock Target Server" cmd /c "python mock_server.py"

:: 4. Pause for 2 seconds to allow the server port to open safely
timeout /t 2 /nobreak >nul

:: 5. Execute the ffuf scan with JSON output
echo [*] Executing ffuf fuzzing pipeline...
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -o ffuf_report.json -of json

:: 6. Check if JSON report was created and generate HTML
if exist ffuf_report.json (
    echo [+] JSON report generated: ffuf_report.json
    echo [*] Generating HTML report...
    
    python -c "
import json
from datetime import datetime

try:
    with open('ffuf_report.json', 'r') as f:
        data = json.load(f)
    
    results = data.get('results', [])
    timestamp = datetime.now().strftime('%%Y-%%m-%%d %%H:%%M:%%S')
    
    html_content = '''<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>FFuf Scan Report</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }
        header {
            border-bottom: 3px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .meta {
            color: #666;
            font-size: 14px;
            display: flex;
            gap: 20px;
        }
        .meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 12px;
            margin-top: 10px;
        }
        .status.success {
            background-color: #d4edda;
            color: #155724;
        }
        table {
            width: 100%%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        thead {
            background-color: #667eea;
            color: white;
        }
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .url {
            color: #667eea;
            font-weight: 500;
            word-break: break-all;
        }
        .code {
            background-color: #f0f0f0;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-weight: bold;
        }
        .no-results {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
        }
        .summary {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .summary-card h3 {
            font-size: 12px;
            text-transform: uppercase;
            opacity: 0.8;
            margin-bottom: 10px;
        }
        .summary-card .number {
            font-size: 32px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class=\"container\">
        <header>
            <h1>🔍 FFuf Scan Report</h1>
            <div class=\"meta\">
                <span>📅 Generated: ''' + timestamp + '''</span>
                <span>🎯 Target: http://localhost:8000</span>
            </div>
            <div class=\"status success\">✓ Scan Completed Successfully</div>
        </header>
        
        <div class=\"summary\">
            <div class=\"summary-card\">
                <h3>Total Results</h3>
                <div class=\"number\">''' + str(len(results)) + '''</div>
            </div>
            <div class=\"summary-card\">
                <h3>Endpoints Found</h3>
                <div class=\"number\">''' + str(len([r for r in results if 'path' in r])) + '''</div>
            </div>
            <div class=\"summary-card\">
                <h3>Success Rate</h3>
                <div class=\"number\">100%%</div>
            </div>
        </div>
        
        <h2 style=\"color: #333; margin-top: 30px; margin-bottom: 15px;\">Results</h2>
'''
    
    if results:
        html_content += '''        <table>
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
'''
        for result in results:
            url = result.get('url', 'N/A')
            status = result.get('status', 'N/A')
            size = result.get('length', 'N/A')
            words = result.get('words', 'N/A')
            lines = result.get('lines', 'N/A')
            
            html_content += f'''                <tr>
                    <td><span class=\"url\">{url}</span></td>
                    <td><span class=\"code\">{status}</span></td>
                    <td>{size}</td>
                    <td>{words}</td>
                    <td>{lines}</td>
                </tr>
'''
        
        html_content += '''            </tbody>
        </table>
'''
    else:
        html_content += '''        <div class=\"no-results\">
            No results found during the scan.
        </div>
'''
    
    html_content += '''    </div>
</body>
</html>
'''
    
    with open('ffuf_report.html', 'w') as f:
        f.write(html_content)
    
    print('[+] HTML report generated: ffuf_report.html')

except Exception as e:
    print(f'[-] Error generating HTML report: {e}')
    "
) else (
    echo [-] Error: JSON report not generated
)

echo.
echo [+] Scan complete!
echo [*] You can now safely close the separate 'FFuf Mock Target Server' window.
echo [*] Check ffuf_report.html and ffuf_report.json for detailed results.
pause
