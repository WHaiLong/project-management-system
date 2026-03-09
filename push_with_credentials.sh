#!/usr/bin/expect -f
set timeout 120
spawn git push https://gitee.com/WHaiLong/project-management-system.git main --force
expect "Username for 'https://gitee.com':"
send "18419360859@163.com\r"
expect "Password for 'https://18419360859@163.com@gitee.com':"
send "28465@Whl\r"
expect eof
