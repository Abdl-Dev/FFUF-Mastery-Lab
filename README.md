# FFuf Mastery Repository (Cross-Platform)

A complete guide and local lab for **ffuf** (Fuzz Faster U Fool). This repository supports execution across both **Linux** and **Windows** systems.

---

## 1. System Dependencies & Prerequisites

Before running `ffuf`, ensure your system meets these baseline needs:

* **`Go` (Golang):** Optional, but required if you intend to compile `ffuf` directly from source code.
* **`Git`:** Required to clone wordlists or the raw tool repositories.
* **`Python 3`:** Essential to spin up the local cross-platform practice web server (`mock_server.py`).

---

## 2. Installation Guide

### For Linux Systems (Ubuntu/Debian/Kali)

* **Using Package Managers (Easiest):**
  ```bash
  sudo apt update && sudo apt install -y ffuf git python3
  ```

* **Installing via Go (From Source):**
  ```bash
  sudo apt update && sudo apt install -y golang git
  go install github.com/ffuf/ffuf/v2@latest
  ```

### For Windows Systems

* **Using Winget (Easiest / Built-in Package Manager):**
  Open PowerShell or Command Prompt as Administrator and run:
  ```powershell
  winget install ffuf.ffuf
  winget install Python.Python.3.11
  winget install Git.Git
  ```

* **Manual Installation:**
  1. Download the pre-compiled Windows `.zip` archive from the [Official FFuf Releases Page](https://github.com/ffuf/ffuf/releases).
  2. Extract the `ffuf.exe` file.
  3. Add the extracted folder path to your Windows **Environment Variables (PATH)** so it runs globally.

---

## 3. Anatomy of a Core Command

Once installed, your baseline command syntax operates identically across both operating systems:

```bash
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404
```

### Word-by-Word Breakdown:

* **`ffuf`**
  * **Meaning:** Fuzz Faster U Fool executable.
  * **Purpose:** Launches the testing program engine (`ffuf` on Linux / `ffuf.exe` on Windows).

* **`-u`**
  * **Meaning:** URL flag.
  * **Purpose:** Instructs the application where to direct network traffic.

* **`http://localhost:8000/FUZZ`**
  * **Meaning:** Target Address String.
  * **Purpose:** The path targeted for testing. The keyword **`FUZZ`** is a mandatory, case-sensitive placeholder. `ffuf` automatically substitutes this keyword with elements from your dictionary.

* **`-w`**
  * **Meaning:** Wordlist flag.
  * **Purpose:** Points the engine directly to your payload dictionary file.

* **`wordlist.txt`**
  * **Meaning:** Dictionary Target File.
  * **Purpose:** A raw text document containing prospective folder names or filenames.

* **`-fc`**
  * **Meaning:** Filter Codes flag.
  * **Purpose:** Drops predefined HTTP response codes from your active UI console feed.

* **`404`**
  * **Meaning:** "Not Found" HTTP status code.
  * **Purpose:** Hides broken link results, isolating valid paths on screen.

---

## 4. How to Use This Local Lab (Cross-Platform)

### Method 1: Automated (Recommended) - One-Click Setup

#### On Linux:
```bash
chmod +x launch_lab.sh
./launch_lab.sh
```

#### On Windows:

**Option A: Double-click in File Explorer**
- Navigate to the repository folder
- Double-click `launch_lab.bat`
- Wait for completion

**Option B: Command Prompt/PowerShell**
```cmd
launch_lab.bat
```

**IMPORTANT:** You MUST be in the correct directory where the files are located!

### Method 2: Manual (If Scripts Don't Work)

#### Step 1: Start the Server

Run the local web server inside your terminal:

**Linux:**
```bash
python3 mock_server.py
```

**Windows (Command Prompt):**
```cmd
python mock_server.py
```

**Windows (PowerShell):**
```powershell
python mock_server.py
```

#### Step 2: Run the Scan (in a new terminal/window)

**Linux:**
```bash
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -o ffuf_report.json -of json
```

**Windows:**
```cmd
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -o ffuf_report.json -of json
```

---

## 5. One-Click Automation Scripts

This repository includes scripts to fully automate running the server and the scan simultaneously, with automatic HTML and JSON reporting:

### On Linux

Run the following command to make the script executable and launch it:

```bash
chmod +x launch_lab.sh
./launch_lab.sh
```

The script will:
1. Verify Python and ffuf are installed
2. Start the mock server in the background
3. Execute the ffuf fuzzing scan
4. Generate `ffuf_report.html` and `ffuf_report.json` in the current directory
5. Automatically shut down the server when complete

### On Windows

Simply **double-click `launch_lab.bat`** inside your file explorer, or open Command Prompt/PowerShell **in the repository folder** and type:

```cmd
launch_lab.bat
```

The script will:
1. Verify Python and ffuf are installed
2. Open the server in a new command window
3. Execute the ffuf fuzzing scan in your active window
4. Generate `ffuf_report.html` and `ffuf_report.json` in the current directory
5. Prompt you when completed (close the server window when done)

---

## 6. Understanding the Reports

After running the automation scripts, you'll find two report files in your directory:

### `ffuf_report.html`
A human-readable HTML report showing:
* All discovered endpoints
* HTTP response codes
* Response sizes
* Status badge (Success/Failure)
* Timestamp of the scan

**Open it in any web browser to view results.**

### `ffuf_report.json`
A machine-readable JSON report containing:
* Scan metadata (timestamp, command used)
* Complete list of results
* Detailed statistics
* Exact ffuf output

**Ideal for parsing, automation, or integrating with other tools.**

---

## 7. Project Structure

```
ffuf-mastery/
├── README.md              # This file (setup & usage guide)
├── mock_server.py         # Local testing environment script
├── wordlist.txt           # Target dictionary file (1000+ entries)
├── launch_lab.sh          # Linux automation script
├── launch_lab.bat         # Windows automation script
└── reports/               # (Auto-created) Reports generated after scans
    ├── ffuf_report.html
    └── ffuf_report.json
```

---

## 8. Complete Troubleshooting Guide

### ⚠️ Common Issues & Solutions

---

### **WINDOWS ISSUES**

#### **Error: `'launch_lab.bat' is not recognized as an internal or external command`**

**Cause:** You're not in the correct directory where the files are located.

**Solution:**
1. Open Command Prompt or PowerShell
2. Navigate to the repository folder:
   ```cmd
   cd C:\path\to\ffuf-mastery
   ```
3. Then run:
   ```cmd
   launch_lab.bat
   ```

**Alternative:** Use File Explorer
1. Open File Explorer
2. Navigate to the `ffuf-mastery` folder
3. Right-click in the empty space → "Open PowerShell window here" or "Open Command Prompt window here"
4. Type: `launch_lab.bat`

---

#### **Error: `python: can't open file 'mock_server.py': [Errno 2] No such file or directory`**

**Cause:** You're not in the repository directory, or Python can't find the file.

**Solution:**
1. Make sure you're in the correct directory:
   ```cmd
   cd C:\path\to\ffuf-mastery
   dir   # Should show: mock_server.py, wordlist.txt, launch_lab.bat, etc.
   ```
2. Then run:
   ```cmd
   python mock_server.py
   ```

---

#### **Error: `CreateFile C:\Users\Administrator\wordlist.txt: The system cannot find the file specified`**

**Cause:** ffuf can't find the wordlist file because you're not in the correct directory.

**Solution:**
1. Change to the repository directory:
   ```cmd
   cd C:\path\to\ffuf-mastery
   ```
2. Verify files are there:
   ```cmd
   dir
   ```
3. Then run ffuf:
   ```cmd
   ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404
   ```

**Absolute Path Method (if still having issues):**
```cmd
ffuf -u http://localhost:8000/FUZZ -w "C:\path\to\ffuf-mastery\wordlist.txt" -fc 404
```

---

#### **Error: `No package found matching input criteria` for Python**

**Cause:** The exact package name might differ in your winget repository.

**Solution:** Try these alternatives:
```powershell
winget install Python.Python.3.11
winget install python
winget search python    # To see available versions
```

Or **download directly** from [python.org](https://www.python.org/downloads/) and install manually.

---

#### **Error: Port 8000 already in use**

**Cause:** Another application is already running on port 8000.

**Solution:**
1. Find the process using port 8000:
   ```cmd
   netstat -ano | findstr :8000
   ```
2. Get the PID (Process ID) from the last column
3. Kill the process:
   ```cmd
   taskkill /PID <PID> /F
   ```
4. Try again

---

#### **Error: `ffuf` command not found**

**Cause:** ffuf is not in your PATH, or installation didn't complete.

**Solution:**
1. Restart PowerShell/Command Prompt completely (close and reopen)
2. Verify installation:
   ```cmd
   ffuf -version
   ```
3. If still not found, add it manually to PATH:
   - Find where ffuf is installed (usually `C:\Users\<username>\AppData\Local\Programs\ffuf\`)
   - Add that folder to Windows Environment Variables
   - Restart all terminals

---

### **LINUX ISSUES**

#### **Error: `Permission denied` when running `launch_lab.sh`**

**Cause:** The script doesn't have executable permissions.

**Solution:**
```bash
chmod +x launch_lab.sh
./launch_lab.sh
```

---

#### **Error: `ffuf: command not found`**

**Cause:** ffuf is not installed.

**Solution:**
```bash
sudo apt update
sudo apt install -y ffuf
```

Or install from source:
```bash
sudo apt install -y golang-go git
go install github.com/ffuf/ffuf/v2@latest
export PATH=$PATH:$HOME/go/bin
```

---

#### **Error: `python3: can't open file 'mock_server.py': [Errno 2] No such file or directory`**

**Cause:** You're not in the repository directory.

**Solution:**
```bash
cd /path/to/ffuf-mastery
python3 mock_server.py
```

---

#### **Error: `Address already in use` on port 8000**

**Cause:** Another process is using port 8000.

**Solution:**
```bash
# Find process on port 8000
lsof -i :8000

# Kill it
kill -9 <PID>
```

Or use a different port by editing `mock_server.py`:
```python
server_address = ('', 8001)  # Change from 8000 to 8001
```

Then run ffuf with the new port:
```bash
ffuf -u http://localhost:8001/FUZZ -w wordlist.txt -fc 404
```

---

#### **Error: `command not found: python3`**

**Cause:** Python 3 is not installed.

**Solution:**
```bash
sudo apt update
sudo apt install -y python3
```

---

#### **Error: No JSON/HTML report generated**

**Cause:** ffuf command failed or the script couldn't create files.

**Solution:**
1. Run ffuf manually to see the actual error:
   ```bash
   ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -o ffuf_report.json -of json
   ```
2. Check if the wordlist file exists:
   ```bash
   ls -la wordlist.txt
   ```
3. Check if the mock server is running:
   ```bash
   curl http://localhost:8000/admin
   ```

---

### **CROSS-PLATFORM ISSUES**

#### **Error: `Connection refused` when running ffuf**

**Cause:** The mock server isn't running.

**Solution:**
1. In a separate terminal/window, start the server:
   ```bash
   python3 mock_server.py  # Linux
   python mock_server.py   # Windows
   ```
2. Wait 2-3 seconds for it to bind to port 8000
3. Run ffuf in another terminal

---

#### **Error: No results found in the report**

**Cause:** The paths in your wordlist don't match the mock server's endpoints.

**Solution:**
1. Check what endpoints the mock server responds to (in `mock_server.py`):
   ```python
   secret_paths = ["/admin", "/backup.bak", "/secret", "/uploads"]
   ```
2. Make sure your `wordlist.txt` contains these exact entries (one per line):
   ```
   admin
   backup.bak
   secret
   uploads
   ```

---

#### **Batch/Script file doesn't run on startup**

**Cause:** Windows is blocking execution or the file association is wrong.

**Solution:**
1. Right-click `launch_lab.bat` → Properties
2. Click "Unblock" at the bottom if available
3. Click Apply → OK
4. Try again

---

## 9. Advanced Usage

### Custom Wordlists

Replace `wordlist.txt` with your own dictionary file. Popular wordlists can be downloaded from:

* **SecLists:** `git clone https://github.com/danielmiessler/SecLists.git`
* **Directory-List-2.3 (Common):** Often included in security distros like Kali
* **Common.txt:** Available in most penetration testing frameworks

### Custom ffuf Parameters

Edit the `ffuf` command inside the automation scripts to add more flags:

```bash
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404 -t 100 -timeout 10
```

**Useful flags:**
- `-t 100` – Number of concurrent threads (default: 40)
- `-timeout 10` – Request timeout in seconds (default: 10)
- `-v` – Verbose mode (show all requests)
- `-r` – Follow redirects
- `-e .php,.html,.txt` – Test file extensions
- `-X POST` – Use POST method instead of GET
- `-H "Authorization: Bearer TOKEN"` – Add custom headers

### Using Different Ports

If port 8000 is unavailable:

1. Edit `mock_server.py`:
   ```python
   server_address = ('', 9000)  # Change from 8000 to 9000
   ```

2. Update the ffuf command:
   ```bash
   ffuf -u http://localhost:9000/FUZZ -w wordlist.txt -fc 404
   ```

---

## 10. Quick Reference

| Task | Command |
|------|---------|
| Run on Linux | `chmod +x launch_lab.sh && ./launch_lab.sh` |
| Run on Windows | Double-click `launch_lab.bat` or `launch_lab.bat` in CMD |
| Manual server (Linux) | `python3 mock_server.py` |
| Manual server (Windows) | `python mock_server.py` |
| Manual ffuf scan | `ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404` |
| Generate JSON report | Add `-o ffuf_report.json -of json` to ffuf command |
| View HTML report | Open `ffuf_report.html` in any web browser |
| Kill process on port 8000 (Linux) | `lsof -ti:8000 \| xargs kill -9` |
| Kill process on port 8000 (Windows) | `netstat -ano \| findstr :8000` then `taskkill /PID <PID> /F` |

---

## License

This repository is provided as-is for educational purposes.
