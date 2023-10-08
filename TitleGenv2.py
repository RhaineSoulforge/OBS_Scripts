import sys
import datetime
from xlwt import Workbook

sDescriptionBlock = """We're now Streaming on Multiple platforms, check us out at:

🟣Twitch - https:://www.twitch.tv/rhaine_soulforge
🔴Youtube - https:://www.youtube.com/@RhaineSoulforge
🟢Kick - https:://www.kick.com/RhaineSoulforge

Times are from 2pm EST to 10pm EST!
Make sure you follow us on Twitter @RhaineSoulforge to get notifications for when and where we're live!

Music by:  https://www.GameChops.com!"""

sTagsSetOne = "Fortnite, w/ the Mrs., FireStarterMay, Game Journal, RhainePlays, Rhaine Soulforge, RhaineSoulforge,"
sTagsSetTwo = "Final Fantasy VI, Pixel Remaster, Game Journal, RhainePlays, RhaineSoulforge, Rhaine Soulforge,"
sFileName = "config.txt"
sResultsFileName = "Results.xls"

lstNoGenDates = []
lstGenDates = []

nNumArgs = len(sys.argv)
nEntryStart = 0
dtStartDate = None 
dtEndDate = None 
lstFileData = []
lstBanned = []
lstTitles = []

def LoadSettings():
    try:
        fin = open(sFileName)
        global lstFileData
        lstFileData = fin.read().split('\n')
        fin.close()
    except:
        print(sFileName, "not found!!!")

def StartEndDates(start,end):
    global dtStartDate,dtEndDate
    lstTemp = start.split('.')
    dtStartDate = datetime.datetime(int(lstTemp[0]),int(lstTemp[1]),int(lstTemp[2]))

    lstTemp = end.split('.')
    dtEndDate = datetime.datetime(int(lstTemp[0]),int(lstTemp[1]),int(lstTemp[2]))
    dtEndDate += datetime.timedelta(days=1)

def MakeBannedList():
    global lstBanned
    nPos = 1
    while lstFileData[nPos] != "<endlist>":
        lstTemp = lstFileData[nPos].split('.')
        result = datetime.datetime(int(lstTemp[0]),int(lstTemp[1]),int(lstTemp[2]))
        lstBanned.append(result)
        nPos += 1

def GenEntries():
    global dtStartDate,dtEndDate,nEntryStart,lstBanned,lstTitles
    while dtStartDate != dtEndDate:
        if dtStartDate not in lstBanned:
            lstTitles.append(" | Game Journal Entry #%d [%02d.%02d.%d]" % (nEntryStart,dtStartDate.month,dtStartDate.day,dtStartDate.year))
            nEntryStart += 1
        dtStartDate += datetime.timedelta(days=1)

def SaveConfig():
    fout = open(sFileName,"w")
    fout.write(str(nEntryStart))
    fout.write('\n')
    fout.write('<endlist>')
    fout.close()

if nNumArgs < 3:
    print("Failed to pass in proper number of arguements.  Example: python TitleGenv2.py 2023.1.1 2023.1.5 <optional filename for results>")

LoadSettings()
nEntryStart = int(lstFileData[0])

StartEndDates(sys.argv[1],sys.argv[2])

MakeBannedList()

if nNumArgs == 4:
    sResultsFileName = sys.argv[3]

GenEntries()

wb = Workbook()
sheet = wb.add_sheet("Sheet 1")

row = 0
for a in lstTitles:
    sheet.write(row,0,a)
    row += 1

sheet.write(0,4,sTagsSetOne)
sheet.write(1,4,sTagsSetTwo)
sheet.write(4,4,sDescriptionBlock)

wb.save(sResultsFileName)
SaveConfig()
print("Processing completed!  Results located in file named: ",sResultsFileName)