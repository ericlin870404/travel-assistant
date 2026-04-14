// scripts/update-schema.js
// 從 Supabase 撈取最新 schema 和 policy 資訊，輸出到 supabase/ 資料夾
// 使用方式：node scripts/update-schema.js
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

// 呼叫 Supabase RPC function
function rpc(functionName) {
    return new Promise((resolve, reject) => {
        const url = new URL(`${SUPABASE_URL}/rest/v1/rpc/${functionName}`);
        const options = {
            hostname: url.hostname,
            path: url.pathname,
            method: 'POST',
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
        req.write('{}');
        req.end();
    });
}

// 將 schema 資料轉成 SQL 格式
function formatSchema(rows) {
    const updated_at = new Date().toISOString();
    let sql = `-- ============================================================\n`;
    sql += `-- 特寶寶旅遊助手 Schema（自動產生，請勿手動編輯）\n`;
    sql += `-- 更新時間：${updated_at}\n`;
    sql += `-- ============================================================\n\n`;

    // 按 table_name 分組
    const tables = {};
    for (const row of rows) {
        if (!tables[row.table_name]) tables[row.table_name] = [];
        tables[row.table_name].push(row);
    }

    for (const [tableName, columns] of Object.entries(tables)) {
        sql += `-- ${tableName}\n`;
        sql += `CREATE TABLE ${tableName} (\n`;
        const cols = columns.map(col => {
            let def = `  ${col.column_name} ${col.data_type}`;
            if (col.is_nullable === 'NO') def += ' NOT NULL';
            if (col.column_default) def += ` DEFAULT ${col.column_default}`;
            return def;
        });
        sql += cols.join(',\n');
        sql += `\n);\n\n`;
    }

    return sql;
}

// 將 policy 資料轉成 SQL 格式
function formatPolicies(rows) {
    const updated_at = new Date().toISOString();
    let sql = `-- ============================================================\n`;
    sql += `-- 特寶寶旅遊助手 RLS Policies（自動產生，請勿手動編輯）\n`;
    sql += `-- 更新時間：${updated_at}\n`;
    sql += `-- ============================================================\n\n`;

    // 按 tablename 分組
    const tables = {};
    for (const row of rows) {
        if (!tables[row.tablename]) tables[row.tablename] = [];
        tables[row.tablename].push(row);
    }

    for (const [tableName, policies] of Object.entries(tables)) {
        sql += `-- ${tableName}\n`;
        for (const p of policies) {
            sql += `CREATE POLICY "${p.policyname}"\n`;
            sql += `  ON ${tableName}\n`;
            sql += `  AS ${p.permissive}\n`;
            sql += `  FOR ${p.cmd}\n`;
            sql += `  TO ${p.roles}\n`;
            if (p.qual) sql += `  USING (${p.qual})\n`;
            if (p.with_check) sql += `  WITH CHECK (${p.with_check})\n`;
            sql += `;\n\n`;
        }
    }

    return sql;
}

async function updateSchema() {
    console.log('🔄 開始更新 schema 文件...');

    try {
        // 查詢 schema 和 policy
        const [schemaRows, policyRows] = await Promise.all([
            rpc('get_schema_info'),
            rpc('get_policy_info')
        ]);

        console.log(`✅ schema：${schemaRows.length} 個欄位`);
        console.log(`✅ policies：${policyRows.length} 個 policy`);

        // 輸出目錄
        const outputDir = path.join(process.cwd(), 'supabase');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        // 寫入檔案（覆蓋前一天的）
        const schemaPath = path.join(outputDir, 'schema.sql');
        const policyPath = path.join(outputDir, 'policies.sql');

        fs.writeFileSync(schemaPath, formatSchema(schemaRows), 'utf8');
        fs.writeFileSync(policyPath, formatPolicies(policyRows), 'utf8');

        console.log(`✅ 已更新：supabase/schema.sql`);
        console.log(`✅ 已更新：supabase/policies.sql`);

    } catch (err) {
        console.error('❌ 更新失敗：', err.message);
        process.exit(1);
    }
}

updateSchema();
