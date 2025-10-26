X = __xonsh__


$XONSH_HISTORY_BACKEND = 'sqlite'
$HISTCONTROL = 'ignoredups'
$AUTO_CD = True

class RandPort:
  def __repr__(self):
    from random import randint
    return str(randint(7000, 8000))

$RANDPORT = RandPort()

aliases["serve"] = "python -m http.server @(__import__('random').randint(6000,6100))"