*** Settings ***

Library                SSHLibrary
Library                String
Library                Collections
Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections


*** Variables ***

${Table}            ZCOL
${Date}             20180313
${Dir}              /gsbpvt
${HostIP}           10.251.87.86
${HostUser}         pvtadm
${HostPass}         ${HostUser}
${File}             ${Table}_${Date}.txt
${LocalPath}        C:/Users/UX305/Desktop
${CMSPath}          ${Dir}/spool/extract/CMS
${CBSPathFrom}      ${Dir}/spool/extract/CMS/FromCMS
${FTPPathFrom}      CMS/FromCMS/${Date}
${SCRIPT_FILE_PUT}  put_ftp.txt
${FTPIP}            10.20.6.58
${FTPHostUser}      cbsist


*** Test Cases ***

Upload File(ZCOL) to Host
    [Documentation]    Upload file ZCOL to Host
    Start Command   rm ${CMSPath}/${file}
    Start Command   rm ${CBSPathFrom}/${file}
    file should not exist  ${CMSPath}/${file}
    file should not exist  ${CBSPathFrom}/${file}
    Put File  ${LocalPath}/${file}     ${CMSPath}
    file should exist  ${CMSPath}/${file}
    Sleep   1s

Put File(ZCOL) to FTP Server
    [Documentation]    Put file ZCOL from ftp sever
    file should exist  ${CMSPath}/${File}
    ${output}=      Execute Command  ${Dir}/Batch/LS_PUT_TEST.sh ${Dir} ${Table}
    Sleep   2s

Get File(ZCOL) from FTP Server
    [Documentation]    Get file ZCOL from ftp sever
    ${output}=      Execute Command  ${Dir}/Batch/LS_GET.sh ${Dir} ${Table}
    file should exist  ${CBSPathFrom}/${File}
    Sleep   2s

Load file(ZCOL)
    [Documentation]    Run Procedure ZCMSREPLICAT, Load table ZCOL
    Write      dm
    Write      D ZCOL^ZCMSREPL
    Write      H
    Sleep      2s


*** Keywords ***

Open Connection And Log In
   Open Connection    ${HostIP}
   Login    ${HostUser}    ${HostPass}
