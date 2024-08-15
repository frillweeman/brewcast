#!/bin/sh
mkdir -p /var/www/hls
ffmpeg -i "http://m1.mixhits.com:8006/;stream.mp3" -c:a aac -b:a 128k -f hls -hls_time 10 -hls_list_size 5 -hls_flags delete_segments -hls_segment_filename "/var/www/hls/segment_%03d.ts" /var/www/hls/stream.m3u8 > /var/log/ffmpeg.log 2>&1
