#!/bin/bash
#进入目录
cd $(cd "$(dirname "$0")";pwd)
#下载规则
urls=(
    "https://gcore.jsdelivr.net/gh/TG-Twilight/AWAvenue-Ads-Rule@main/AWAvenue-Ads-Rule.txt"
    "https://cdn.jsdelivr.net/gh/blackmatrix7/ios_rule_script@master/rule/AdGuard/Advertising/Advertising.txt"
)

for url in "${urls[@]}"; do
    curl -sS "$url" >> dns.txt
done
#添加自定义规则
cat ../rules/myrules.txt >> dns.txt
#修复换行符问题
sed -i 's/\r//' dns.txt
#去重
python sort.py dns.txt 
#备份纯合并文件
cp -rf dns.txt ../rules/dns2.txt
sed -i "/秋风广告规则/d" ../rules/dns2.txt
#压缩优化
hostlist-compiler -c dns.json -o dns-output.txt
#仅输出黑名单
cat dns-output.txt | grep -P "^\|\|.*\^$" > dns.txt
#再次排序
python sort.py dns.txt 
#移动规则
mv dns.txt ../rules/dns.txt
#清除缓存
rm -rf ./*.txt
