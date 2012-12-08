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

