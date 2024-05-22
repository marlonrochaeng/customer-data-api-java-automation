# Instructions for Installation and Execution of Automated Tests

## 1. Install Python version 3.12.3
#### 1.1 For Windows, visit the website: [Python Downloads](https://www.python.org/downloads/)
#### 1.2 Download the installer for the desired version and follow the installation steps
#### 1.3 Don't forget to check the option to add Python to the path/environment variables
#### For macOS and Linux, I recommend using PyEnv: [PyEnv GitHub](https://github.com/pyenv/pyenv)

## 2. Download and install PyCharm Community
#### 2.1 Installation requires assistance from the Infrastructure/IT team as it requires administrator access
#### 2.2 Here is the download link: [PyCharm Download](https://www.jetbrains.com/pycharm/download/)

## 3. Clone the automation repository
#### 3.1 Repository link: [https://github.com/marlonrochaeng/customer-data-api-java-automation](https://github.com/marlonrochaeng/customer-data-api-java-automation)

## 4. In PyCharm, open the automation repository as a new project
#### 4.1 In a terminal within PyCharm, at the project root, type the command `pip install -r requirements.txt` to promptly install all necessary libs

## 5. Test Execution
#### 5.1 Run all tests: `robot .`
#### 5.2 Run all tests in a file: `robot /path/to/test/test.robot`
#### 5.3 Run tests with a specific tag: `robot -i tagName .`
#### 5.4 Run tests containing multiple tags: `robot -i tagName1 -i tagName2 .`

## 6. Test Execution on Docker
#### 6.1 Build the docker image with `docker run --rm robot-tests`
#### 6.2 Run it with `docker run --network="host" --rm robot-tests`
