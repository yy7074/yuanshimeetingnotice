<?php

/**
 * 邮件发送配置
 * 使用Foxmail发送邮件的SMTP配置
 */

return [
    'smtp' => [
        'host' => 'smtp.qq.com',
        'port' => 465,
        'username' => 'gpsgo@foxmail.com',     // 密码找回专用邮箱
        'password' => 'klpdqsfrdrrsbhbd',      // QQ邮箱授权码
        'secure' => 'ssl',                     // SSL (465)，如改587请用'tls'
        'from' => 'gpsgo@foxmail.com',         // 发件人邮箱
        'from_name' => 'APP名字',   // 发件人名称
    ],
    // 备用SMTP配置 - Gmail (需要配置应用专用密码)
    'smtp_backup' => [
        'host' => 'smtp.gmail.com',
        'port' => 587,
        'username' => '',                       // 请配置Gmail邮箱
        'password' => '',                       // 请配置Gmail应用专用密码
        'secure' => 'tls',                     // Gmail使用TLS
        'from' => '',                          // 发件人邮箱
        'from_name' => 'CarGPS车辆定位系统',   // 发件人名称
    ],
    // 是否启用备用SMTP
    'use_backup' => false,
]; 