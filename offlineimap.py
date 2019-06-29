import os
from subprocess import Popen, PIPE

prioritized = ['INBOX', 'mitsi']
def mycmp(x, y):
  for folder in prioritized:
    xis = x == folder
    yis = y == folder
    if xis and yis:
      return cmp(x, y)
    elif xis:
      return -1
    elif yis:
      return +1
  return cmp(x, y)

def getuser():
  return os.getenv("EMAIL")

def getpass():
  process = Popen(["netrc-password", "imap.gmail.com", os.getenv("EMAIL")], stdout=PIPE)
  (output, err) = process.communicate()
  exit_code = process.wait()
  return output
