import os, sys

MASTER_HOST=os.environ['BUILDBOT_MASTER_HOST']
MASTER_PORT=os.environ['BUILDBOT_MASTER_PORT']
SLAVE_NAME=os.environ['BUILDBOT_SLAVE_NAME']
SLAVE_PASS=os.environ['BUILDBOT_SLAVE_PASS']

for k in os.environ.keys():
    clear = False;
    if k in ['APP_GID', 'APP_UID', 'container_uuid']:
        clear = True
    if k in ['BUILDBOT_MASTER_HOST', 'BUILDBOT_MASTER_PORT', 'BUILDBOT_SLAVE_NAME', 'BUILDBOT_SLAVE_PASS']:
        clear = True
    if k.startswith('SUPERVISOR_'):
        clear = True
    if k in ['PS1', 'LS_COLORS', 'LESSOPEN', 'LOGNAME', 'VIRTUAL_ENV', '_', 'OLDPWD', 'MAIL', 'PYTHONPATH', 'SHLVL']:
        clear = True
    if k.startswith('SSH'):
        clear = True
    if k.startswith('HIST'):
        clear = True
    if k.startswith('KDE'):
        clear = True
    if k.startswith('QT'):
        clear = True
    if clear:
        del os.environ[k]

from twisted.application import service
from buildslave.bot import BuildSlave

basedir = '.'
rotateLength = 10000000
maxRotatedFiles = 10

# if this is a relocatable tac file, get the directory containing the TAC
if basedir == '.':
    import os.path
    basedir = os.path.abspath(os.path.dirname(__file__))

# note: this line is matched against to check that this is a buildslave
# directory; do not edit it.
application = service.Application('buildslave')

try:
  from twisted.python.logfile import LogFile
  from twisted.python.log import ILogObserver, FileLogObserver
  logfile = LogFile.fromFullPath(os.path.join('/build/logs', "twistd.log"), rotateLength=rotateLength,
                                 maxRotatedFiles=maxRotatedFiles)
  application.setComponent(ILogObserver, FileLogObserver(logfile).emit)
except ImportError:
  # probably not yet twisted 8.2.0 and beyond, can't set log yet
  pass

buildmaster_host = MASTER_HOST
port = int(MASTER_PORT)
slavename = SLAVE_NAME
passwd = SLAVE_PASS
keepalive = 300
usepty = 0
umask = None
maxdelay = 60
allow_shutdown = True

s = BuildSlave(buildmaster_host, port, slavename, passwd, '/build/',
               keepalive, usepty, umask=umask, maxdelay=maxdelay,
               allow_shutdown=allow_shutdown)
s.setServiceParent(application)

buildmaster_host = MASTER_HOST
port = int(MASTER_PORT)
slavename = SLAVE_NAME + '-2'
passwd = SLAVE_PASS
keepalive = 300
usepty = 0
umask = None
maxdelay = 60
allow_shutdown = True

s = BuildSlave(buildmaster_host, port, slavename, passwd, '/build-2/',
               keepalive, usepty, umask=umask, maxdelay=maxdelay,
               allow_shutdown=allow_shutdown)
s.setServiceParent(application)

buildmaster_host = MASTER_HOST
port = int(MASTER_PORT)
slavename = SLAVE_NAME + '-3'
passwd = SLAVE_PASS
keepalive = 300
usepty = 0
umask = None
maxdelay = 60
allow_shutdown = True

s = BuildSlave(buildmaster_host, port, slavename, passwd, '/build-3/',
               keepalive, usepty, umask=umask, maxdelay=maxdelay,
               allow_shutdown=allow_shutdown)
s.setServiceParent(application)


buildmaster_host = 'dev.ocv'
port = int(MASTER_PORT)
slavename = SLAVE_NAME
passwd = SLAVE_PASS
keepalive = 300
usepty = 0
umask = None
maxdelay = 60
allow_shutdown = True

s = BuildSlave(buildmaster_host, port, slavename, passwd, '/build-dev/',
               keepalive, usepty, umask=umask, maxdelay=maxdelay,
               allow_shutdown=allow_shutdown)
s.setServiceParent(application)
