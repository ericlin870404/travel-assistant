// scripts/backup.js
// 備份所有行程資料到 backups/ 資料夾
// 使用方式：node scripts/backup.js
// 環境變數：SUPABASE_URL, SUPABASE_SECRET_KEY

const https = require('https');
const fs = require('fs');
const path = require('path');

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://lcdugmmnjfrvfdbzpwma.supabase.co';
const SUPABASE_KEY = process.env.SUPABASE_SECRET_KEY;

if (!SUPABASE_KEY) {
    console.error('❌ 缺少 SUPABASE_SECRET_KEY 環境變數');
    process.exit(1);
}

// 通用 Supabase REST API 查詢
function query(table, params = '') {
    return new Promise((resolve, reject) => {
        const url = new URL(`${SUPABASE_URL}/rest/v1/${table}${params ? '?' + params : ''}`);
        const options = {
            hostname: url.hostname,
            path: url.pathname + url.search,
            method: 'GET',
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`,
                'Content-Type': 'application/json'
            }
        };
        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try {
                    resolve(JSON.parse(data));
                } catch (e) {
                    reject(new Error(`解析失敗：${data}`));
                }
            });
        });
        req.on('error', reject);
        req.end();
    });
}

async function backup() {
    console.log('🔄 開始備份...');

    try {
        // 1. 取得所有行程
        const trips = await query('trips', 'select=*&order=created_at.asc');
        console.log(`✅ trips：${trips.length} 筆`);

        // 2. 取得所有相關資料
        const [
            scheduleItems,
            stays,
            transportGroups,
            transportDetails,
            restaurants,
            attractions,
            expenses,
            currencies,
            photos
        ] = await Promise.all([
            query('schedule_items', 'select=*&order=date.asc,time.asc'),
            query('stays', 'select=*&order=date.asc'),
            query('transport_groups', 'select=*&order=created_at.asc'),
            query('transport_details', 'select=*&order=date.asc'),
            query('restaurants', 'select=*&order=created_at.asc'),
            query('attractions', 'select=*&order=created_at.asc'),
            query('expenses', 'select=*&order=date.asc,created_at.asc'),
            query('currencies', 'select=*&order=created_at.asc'),
            query('trip_day_photos', 'select=*&order=date.asc,sort_order.asc'),
        ]);

        console.log(`✅ schedule_items：${scheduleItems.length} 筆`);
        console.log(`✅ stays：${stays.length} 筆`);
        console.log(`✅ transport_groups：${transportGroups.length} 筆`);
        console.log(`✅ transport_details：${transportDetails.length} 筆`);
        console.log(`✅ restaurants：${restaurants.length} 筆`);
        console.log(`✅ attractions：${attractions.length} 筆`);
        console.log(`✅ expenses：${expenses.length} 筆`);
        console.log(`✅ currencies：${currencies.length} 筆`);
        console.log(`✅ trip_day_photos：${photos.length} 筆`);

        // 3. 組合備份物件
        const backupData = {
            backup_at: new Date().toISOString(),
            tables: {
                trips,
                schedule_items: scheduleItems,
                stays,
                transport_groups: transportGroups,
                transport_details: transportDetails,
                restaurants,
                attractions,
                expenses,
                currencies,
                trip_day_photos: photos
            }
        };

        // 4. 寫入檔案
        const backupDir = path.join(process.cwd(), 'backups');
        if (!fs.existsSync(backupDir)) {
            fs.mkdirSync(backupDir, { recursive: true });
        }

        const timestamp = new Date().toISOString().slice(0, 10);
        const filename = path.join(backupDir, `backup_${timestamp}.json`);
        fs.writeFileSync(filename, JSON.stringify(backupData, null, 2), 'utf8');

        console.log(`\n✅ 備份完成：backups/backup_${timestamp}.json`);

        // 5. 只保留最近 30 份備份
        const files = fs.readdirSync(backupDir)
            .filter(f => f.startsWith('backup_') && f.endsWith('.json'))
            .sort();
        if (files.length > 30) {
            const toDelete = files.slice(0, files.length - 30);
            toDelete.forEach(f => {
                fs.unlinkSync(path.join(backupDir, f));
                console.log(`🗑️  刪除舊備份：${f}`);
            });
        }

    } catch (err) {
        console.error('❌ 備份失敗：', err.message);
        process.exit(1);
    }
}

backup();
