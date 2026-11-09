// 由前端 cases.js 生成 case_file 的 INSERT 语句，追加到 admin_module_init.sql
import fs from 'node:fs'
import { CASES } from './meiying-shenbu-vue/src/data/cases.js'

const esc = (v) => String(v ?? '').replace(/\\/g, '\\\\').replace(/'/g, "''")
const rows = CASES.map((c) => `  (${c.id}, '${esc(c.no)}', '${esc(c.title)}', '${esc(c.tag)}', '${esc(c.desc)}', '${esc(c.place)}', '${esc(c.status)}', '${esc(c.reward)}', '${esc(c.image)}', '${esc(c.summary)}', 1)`)
const sql = `
INSERT IGNORE INTO \`case_file\`
  (\`id\`, \`case_no\`, \`title\`, \`tag\`, \`description\`, \`place\`, \`status\`, \`reward\`, \`image\`, \`summary\`, \`is_active\`) VALUES
${rows.join(',\n')};

SELECT 'case_file' AS 表, COUNT(*) AS 行数 FROM \`case_file\`
UNION ALL SELECT 'site_config', COUNT(*) FROM \`site_config\`;
`
fs.appendFileSync('springBootTest/sql/admin_module_init.sql', sql, 'utf8')
console.log('appended', CASES.length, 'cases')
