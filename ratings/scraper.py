import time

from selenium import webdriver
import chromedriver_autoinstaller

from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys

from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support import expected_conditions as EC

from bs4 import BeautifulSoup
import threading
import unicodedata
import json

#make a 'login.txt' file in the same directory with your GT username on the firstline and password on second
try:
    with open("login.txt", "r") as LOGIN:
        USERNAME = LOGIN.readline().rstrip()
        PASSWORD = LOGIN.readline().rstrip()
        LOGIN.close()
except:
    raise Exception("CANNOT PROCEED, No login.txt file found")

chromedriver_autoinstaller.install()

DRIVER = webdriver.Chrome()
DEBUG_MODE = False
WAIT = WebDriverWait(DRIVER, 25)

def goToCIOS():
    DRIVER.get("https://gatech.smartevals.com/")
    #return error_handler(element_to_find="username", method_to_find="name", purpose="Selecting GT")
    return print("accessed smartevals")

def loginGT():
    gatech_login_username = DRIVER.find_element_by_name("username")
    gatech_login_password = DRIVER.find_element_by_name("password")

    gatech_login_username.send_keys(USERNAME)
    gatech_login_password.send_keys(PASSWORD)

    submit_button = DRIVER.find_element_by_name("submit")
    submit_button.click()

    print("Please authenticate on Duo")
    WAIT.until(lambda DRIVER: DRIVER.find_element_by_id("lnkSeeResultsImg"))
    #return error_handler(element_to_find="duo_form", method_to_find="id", purpose="Logging In")
    return print("accessed Duo form")

def goToResults(reportType):
    #reportType of Classes, Instructors, Sections
    DRIVER.get("https://mwfea.smartevals.com/Reporting/Students/Results.aspx?Type={0}&ShowAll=Chosen".format(reportType))
    return print("accessed ratings page")

def goToCourseDescription(CRN):
    #course registration number
    year = 2021
    term = "02"
    DRIVER.get("https://coursedescription.eduapps.gatech.edu/{1}/{0}".format(str(CRN), str(year)+term))
    return print("accessed {} course description".format(CRN), end='\r', flush=True)

def goToNextPage():
    next_button = DRIVER.find_elements_by_css_selector("[aria-label=Next]")
    #next_button[0].click()
    DRIVER.execute_script("arguments[0].click();", next_button[0])
    #WAIT.until(EC.element_to_be_clickable((By.CSS_SELECTOR, "[aria-label=Next]"))).click()

    #return print("accessed next page")

def scrapePage(keys = False, keysTypes = False, getKeys = False):
    pageSource = DRIVER.page_source
    soup = BeautifulSoup(pageSource, 'html.parser')

    if getKeys:
        #parse in header categories
        keys = soup.find('tr', {'id': '_ctl0_cphContent_grd1_DXHeadersRow0'}).select("a")
        keys[:] = [i.contents[0] for i in keys]
        sampleValues = soup.findAll('tr', id=lambda x: x and x.startswith('_ctl0_cphContent_grd1_DXDataRow'))[0].select("td")
        sampleValues[:] = [i.contents[0] for i in sampleValues]
        keysTypes = processKeys(keys, sampleValues)
        totalStats = soup.find('b', {'class': 'dxp-lead dxp-summary'}).contents[0]
        totalStats = [int(totalStats.replace('(','').split(' ')[i]) for i in [3, 4]]

    #parse in individual entries
    entries = soup.findAll('tr', id=lambda x: x and x.startswith('_ctl0_cphContent_grd1_DXDataRow'))
    entries[:] = [i.select("td") for i in entries]
    entries = [[unicodedata.normalize('NFKD', j.contents[0]) for j in i] for i in entries]

    #convert to respective data types
    for i in range(0,len(entries)):
        try:
            entries[i] = entries[i][:keys.index("Pct")] + [entries[i][keys.index("Pct")].replace('%','')] + entries[i][keys.index("Pct")+1:]
        except:
            pass
        for j in range(0,len(entries[i])):
            try:
                entries[i][j] = keysTypes[j](entries[i][j])
            except:
                if entries[i][j] == " ": entries[i][j] = None

    return (keys, keysTypes, totalStats, entries) if getKeys else entries

def scrapeDescription():
    pageSource = DRIVER.page_source
    soup = BeautifulSoup(pageSource, 'html.parser')
    try:
        description = unicodedata.normalize('NFKD', soup.find('p').get_text())
        if "description unavailable" in description: return
        return description
    except:
        return

def processKeys(keys, sampleVals):
    #determine respective data types with keys and a samplevalue list
    dataTypes = [int, float, str]
    keysTypes = [None] * len(keys)
    for i in range(0,len(sampleVals)):
        try:
            int(sampleVals[i])
            keysTypes[i] = dataTypes[0]
        except ValueError:
            try:
                float(sampleVals[i].replace('%',''))
                keysTypes[i] = dataTypes[1]
            except ValueError:
                keysTypes[i] = dataTypes[2]
    #Course Number has to be chars but sample value might be an integer
    keysTypes[keys.index("Num")] = dataTypes[2]

    return keysTypes

def initSteps():
    goToCIOS()
    loginGT()
    goToResults("Sections")

# def scrapeResults():
#     keys, totalStats, entries = scrapePage(True)
#     for i in range(2,totalStats[0]-1):
#         goToNextPage()
#         scrapePage()

def scrapeResults():
    allEntries = []
    keys, keysTypes, totalStats, entries = scrapePage(False, False, True)
    allEntries += entries
    for i in range(2, totalStats[0]+1):
        goToNextPage()
        entries = scrapePage(keys, keysTypes)
        allEntries += entries
        print(len(allEntries), ' entries done', end='\r', flush=True)
        #print(end="\r")

    return keys, keysTypes, allEntries

def scrapeDescriptions():
    start = time.time()
    with open('../../buzzbook-frontend/src/courseDataWithGrades.json') as file:
        data = json.load(file)
    courseList = data["courses"]
    descriptionDict = {}
    for course in courseList:
        sectionDict = {}
        sectionList = courseList[course][1]
        for section in sectionList:
            CRN = int(sectionList[section][0])
            goToCourseDescription(CRN)
            try:
                 current = scrapeDescription()
                 for key, value in sectionDict.items():
                     if current == value:
                         sectionDict[key + (CRN,)] = sectionDict.pop(key)
                         break
                 else:
                     sectionDict[(CRN,)] = current
            except:
                pass
        try:
            descriptionDict[course] = sectionDict
        except:
            pass
    end = time.time()
    print(end - start, " elapsed time")
    return descriptionDict

def scrapeDescriptionsUnsorted():
    start = time.time()
    with open('../../buzzbook-frontend/src/courseDataWithGrades.json') as file:
        data = json.load(file)
    CRNList = CRNs()
    descriptionCache = []
    descriptionMap = {}
    for CRN in CRNList:
        goToCourseDescription(CRN)
        current = scrapeDescription()
        if current != None:
            try:
                descriptionMap[CRN] = descriptionCache.index(current)
            except:
                descriptionMap[CRN] = len(descriptionCache)
                descriptionCache.append(current)
    return descriptionCache, descriptionMap


def CRNs():
    with open('../../buzzbook-frontend/src/courseDataWithGrades.json') as file:
        data = json.load(file)
    CRNs = []
    Courses = []
    courseList = data["courses"]
    for course in courseList:
        Courses.append(course)
        sectionList = courseList[course][1]
        for section in sectionList:
            CRNs.append(int(sectionList[section][0]))
    return CRNs, Courses

def scrapeDescriptionsParallel():
    CRNList = CRNs()
    #threads = [threading.Thread(target = scrapeDescription, args = (CRN, ) for CRN in CRNList)]
    for t in thread:
        t.start()
    #not finished, would need to have many webdrivers, and multiple DUO signins :/
