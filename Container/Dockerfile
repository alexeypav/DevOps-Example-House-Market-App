FROM mcr.microsoft.com/powershell:ubuntu-16.04
ENV TZ=Pacific/Auckland
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN apt-get update && apt-get install -y zip unzip
RUN apt-get update && apt-get install -y libunwind8
RUN apt-get update && apt-get install -y libicu55
RUN apt-get install -y tzdata
#COPY tools ./tools
#RUN unzip ./tools/sqlpackage-linux-x64-150.4316.1.zip -d ./sqlpackage
#RUN chmod a+x ./sqlpackage/sqlpackage

SHELL [ "pwsh","-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]
#RUN Install-Module -Name Az -AllowClobber -Force -Confirm:$false
#COPY sqlscripts ./sqlscripts
#COPY config ./config
#COPY modules /usr/local/share/powershell/Modules/
COPY PWSH ./powershell

#RUN chmod a+x ./config
#RUN chmod a+x /usr/local/share/powershell/Modules/
RUN chmod a+x ./powershell

ENTRYPOINT [ "pwsh","./powershell/Get-Listings.ps1"]
