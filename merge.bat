@ECHO OFF
Set D=%1
IF EXIST %D%\in.txt (
 del %D%\in.txt
)
(for %%F in (%D%\in\*_*) do (
    type %%F
    echo(
  )
) > %D%\corr.txt
IF EXIST %D%\out.txt (
 del %D%\out.txt
)
(for %%F in (%D%\out\*_*) do (
    type %%F
	echo(
  )
) >> %D%\corr.txt
