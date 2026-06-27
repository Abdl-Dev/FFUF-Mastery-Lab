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
  winget install Python.Python.3
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

### Manual Method

#### Step 1: Start the Server

Run the local web server inside your terminal (Linux) or Command Prompt/PowerShell (Windows):

```bash
python mock_server.py
```

*(Note: Use `python3 mock_server.py` on Linux if `python` points to an older version).*

#### Step 2: Run the Scan

Open a **second terminal frame or command window** and execute the scanner:

```bash
ffuf -u http://localhost:8000/FUZZ -w wordlist.txt -fc 404
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

Simply **double-click `launch_lab.bat`** inside your file explorer, or open Command Prompt/PowerShell inside the folder and type:

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
├── wordlist.txt           # Target dictionary file
├── launch_lab.sh          # Linux automation script
├── launch_lab.bat         # Windows automation script
└── reports/               # (Auto-created) Reports generated after scans
    ├── ffuf_report.html
    └── ffuf_report.json
```

---

## 8. Troubleshooting

### On Linux:
- **`Permission denied` when running `launch_lab.sh`?** Run `chmod +x launch_lab.sh` first.
- **`ffuf: command not found`?** Install ffuf with `sudo apt install ffuf` or `go install github.com/ffuf/ffuf/v2@latest`.
- **`Address already in use`?** Another process is using port 8000. Kill it with `lsof -ti:8000 | xargs kill -9`.

### On Windows:
- **`ffuf is not recognized`?** Ensure ffuf is in your PATH or download it from [releases](https://github.com/ffuf/ffuf/releases).
- **`python is not recognized`?** Install Python from [python.org](https://www.python.org) and ensure "Add to PATH" is checked during installation.
- **Port 8000 already in use?** Open Task Manager, find the process using port 8000, and terminate it.

---

## 9. Advanced Usage

### Custom Wordlists

Replace `wordlist.txt` with your own dictionary file. Popular wordlists can be downloaded from:

* **SecLists:** `git clone https://github.com/danielmiessler/SecLists.git`
* **Directory-List-2.3 (Common):** Often included in security distros like Kali

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

---

## License

This repository is provided as-is for educational purposes.
