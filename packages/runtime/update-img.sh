#!/bin/bash

# 删除旧的文件系统目录
rm -rf filesystem/

# 复制新的文件系统
cp -r ../buildroot/build/filesystem .

# 从 filesystem.json 中提取 bzImage 文件名
bzimage_filename=$(jq -r '.fsroot | map(select(.[0] == "bzImage"))[0][6]' < filesystem/filesystem.json)

if [ -n "$bzimage_filename" ]; then
    echo "Found bzImage filename: $bzimage_filename"
    
    # 更新 index.html 中的 bzimageUrl
    sed -i "s|const bzimageUrl = \"./filesystem/[^\"]*\";|const bzimageUrl = \"./filesystem/$bzimage_filename\";|g" index.html
    
    echo "Updated index.html with new bzimageUrl: ./filesystem/$bzimage_filename"
else
    echo "Error: Could not find bzImage filename in filesystem.json"
    exit 1
fi

