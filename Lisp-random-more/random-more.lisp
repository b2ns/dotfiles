;;;;Description: generate random things more than number
;;;;Author: b2ns

(defpackage :b2ns.github.random-more
  (:use :cl)
  (:export :random-num :random-num-range :random-string :random-alpha :random-digital :random-name :random-array))
(in-package :b2ns.github.random-more)

;;;number
(defun random-num (&optional (start 100)  (end 0))
  (if (< start end) (rotatef start end))
  (+ end (random (- start end))))

(defun random-num-range (&rest body)
  (let* ((len (/ (length body) 2)) (rand (* 2 (random len))))
    (random-num (nth rand body) (nth (1+ rand) body))))

;;;string
(defmacro with-random-string (&body nums)
  `(let ((str (make-array max-len :element-type 'character :fill-pointer 0 :adjustable t)))
    (if random-len (setf max-len (+ min-len (random max-len))))
    (loop repeat max-len do
          (vector-push-extend (code-char (random-num-range ,@nums)) str))
    str))

(defun random-string (&key (max-len 10) (random-len nil) (min-len 1))
  (with-random-string 32 127)
  )

(defun random-alpha (&key (max-len 1) (random-len nil) (min-len 1) (upper nil) (lower nil))
  (cond 
    (upper (with-random-string 65 91))
    (lower (with-random-string 97 123))
    (t (with-random-string 65 91 97 123))))

(defun random-digital (&key (max-len 1) (random-len nil) (min-len 1))
  (with-random-string 48 58))

(defun random-name ()
  (let ((n (random 10)) (name ""))
    (cond
      ((= n 9) (setf n 3))
      ((and (> n 3) (< n 9)) (setf n 1))
      (t (setf n 2)))
    (setf name (concatenate 'string name (format nil "~a" (nth (random (length *first-name*)) *first-name*))))
    (loop repeat n do
        (setf name (concatenate 'string name (format nil "~a" (nth (random (length *last-name*)) *last-name*)))))
    name))




;;;array
(defun random-array (&key (size 100) (range 100))
  (let ((arr (make-array size)))
    (dotimes (i size)
      (setf (aref arr i) (random range)))
    arr))



;;;;name dictionary
(defparameter *first-name* '(
赵	钱	孙	李	周	吴	郑	王	冯	陈	褚	卫	蒋	沈	韩	杨	朱	秦	尤	许
何	吕	施	张	孔	曹	严	华	金	魏	陶	姜	戚	谢	邹	喻	柏	水	窦	章
云	苏	潘	葛	奚	范	彭	郎	鲁	韦	昌	马	苗	凤	花	方	俞	任	袁	柳
酆	鲍	史	唐	费	廉	岑	薛	雷	贺	倪	汤	滕	殷	罗	毕	郝	邬	安	常
乐	于	时	傅	皮	卞	齐	康	伍	余	元	卜	顾	孟	平	黄	和	穆	萧	尹
姚	邵	湛	汪	祁	毛	禹	狄	米	贝	明	臧	计	伏	成	戴	谈	宋	茅	庞
熊	纪	舒	屈	项	祝	董	梁	杜	阮	蓝	闵	席	季	麻	强	贾	路	娄	危
江	童	颜	郭	梅	盛	林	刁	钟	徐	邱	骆	高	夏	蔡	田	樊	胡	凌	霍
虞	万	支	柯	昝	管	卢	莫	经	房	裘	缪	干	解	应	宗	丁	宣	贲	邓
郁	单	杭	洪	包	诸	左	石	崔	吉	钮	龚	程	嵇	邢	滑	裴	陆	荣	翁
荀	羊	於	惠	甄	麴	家	封	芮	羿	储	靳	汲	邴	糜	松	井	段	富	巫
乌	焦	巴	弓	牧	隗	山	谷	车	侯	宓	蓬	全	郗	班	仰	秋	仲	伊	宫
宁	仇	栾	暴	甘	钭	厉	戎	祖	武	符	刘	景	詹	束	龙	叶	幸	司	韶
郜	黎	蓟	薄	印	宿	白	怀	蒲	邰	从	鄂	索	咸	籍	赖	卓	蔺	屠	蒙
池	乔	阴	郁	胥	能	苍	双	闻	莘	党	翟	谭	贡	劳	逄	姬	申	扶	堵
冉	宰	郦	雍	舄	璩	桑	桂	濮	牛	寿	通	边	扈	燕	冀	郏	浦	尚	农
温	别	庄	晏	柴	瞿	阎	充	慕	连	茹	习	宦	艾	鱼	容	向	古	易	慎
戈	廖	庾	终	暨	居	衡	步	都	耿	满	弘	匡	国	文	寇	广	禄	阙	东
殴	殳	沃	利	蔚	越	夔	隆	师	巩	厍	聂	晁	勾	敖	融	冷	訾	辛	阚
那	简	饶	空	曾	毋	沙	乜	养	鞠	须	丰	巢	关	蒯	相	查	後	荆	红
游	竺	权	逯	盖	益	桓	公	万俟	司马	上官	欧阳	夏侯	诸葛
闻人	东方	赫连	皇甫	尉迟	公羊	澹台	公冶	宗政	濮阳
淳于	单于	太叔	申屠	公孙	仲孙	轩辕	令狐	钟离	宇文
长孙	慕容	鲜于	闾丘	司徒	司空	亓官	司寇	仉	督	子车
颛孙	端木	巫马	公西	漆雕	乐正	壤驷	公良	拓跋	夹谷
宰父	谷梁	晋	楚	闫	法	汝	鄢	涂	钦	段干	百里	东郭	南门
呼延	归	海	羊舌	微生	岳	帅	缑	亢	况	后	有	琴	梁丘	左丘
东门	西门	商	牟	佘	佴	伯	赏	南宫	墨	哈	谯	笪	年	爱	阳	佟
第五	言	福))

(defparameter *last-name* '(
伟 勇 军 磊 涛 斌 强 鹏 杰 峰 超 波 辉 刚 健 明 亮 俊 飞 凯 浩 华 平 鑫 毅 林 洋 宇 敏 宁 建 兵 旭 雷 锋 彬 龙 翔 阳 剑 东 博 威 海 巍 晨 炜 帅 岩 江 松 文 云 力 成 琦 进 昊 宏 欣 坤 冰 锐 震 楠 佳 忠 庆 杨 新 骏 君 栋 青 帆 静 荣 立 虎 哲 晖 玮 瑞 光 钢 丹 坚 振 晓 祥 良 春 晶 猛 星 政 智 琪 永 迪 冬 琳 胜 康 彪 乐 诚 志 维 卫 睿 捷 群 森 洪 扬 科 奇 铭 航 利 鸣 恒 源 聪 凡 颖 欢 昕 武 雄 洁 川 清 义 滨 皓 达 民 跃 越 兴 正 靖 曦 璐 挺 淼 泉 程 韬 冲 硕 远 昆 瑜 晔 煜 红 权 征 雨 野 慧 萌 山 丰 珂 彤 悦 朋 钧 彦 然 枫 嘉 峥 寅 烨 铮 卓 畅 钊 金 可 昱 爽 盛 路 晋 谦 克 方 闯 耀 奎 一 晟 勤 豪 安 尧 全 琛 腾 队 鸿 玉 泽 凌 渊 蕾 广 顺 莹 英 峻 攀 宾 驰 燕 霖 喆 椒 国 恺 潇 琨 轶 芳 吉 亚 梁 焱 侃 臻 嵩 岳 炯 艳 宝 岗 斐 啸 元 辰 萍 柯 羽 培 通 天 麟 晗 菲 雪 铁 贺 钰 戈 灿 琼 锦 生 原 洲 炎 丽 勋 奕 艺 中 德 轩 京 标 旺 南 黎 禹 莉 蔚 总 益 祺 骥 沛 汉 真 非 鹤 升 蒙 城 钦 锴 骁 壮 罡 键 瑶 虹 石 展 翼 为 灏 玲 放 娜 露 赞 娟 倩 懿 劲 婷 策 魁 霄 冉 敬 卿 均 治 迅 臣 桦 镇 骞 河 希 瑾 鹰 舟 丁 涵 弘 纲 泳 理 福 俭 乾 纯 双 屹 涌 根 怡 果 田 岭 昭 飚 勃 嵘 熙 贤 申 琰 宽 鼎 滔 昌 璞 逸 贵 喜 昂 柳 韶 瑛 伦 茂 景 柱 岚 实 珏 霞 园 学 惠 衡 风 玺 赫 桐 寒 圣 陈 旋 礼 霆 月 侠 密 堃 富 薇 仁 浪 津 垒 齐 炼 瀚 泓 灵 朝 夏 严 意 银 璇 鲲 易 行 品 垄 靓 苏 澄 赛 思 旗 淳 雯 继 友 和 革 延 能 菁 叶 隽 烽 昶 笑 裕 鲁 铎 昀 骅 高 翀 润 熠 锟 望 卡 微 拓 名 秋 冶 雁 开 定 想 舒 庚 蓉 牧 重 孟 澎 信 郁 珉 钟 盼 恩 周 潮 季 烈 魏 奔 承 玎 来 桥 尚 增 婧 茜 前 琴 麒 竞 童 舜 会 柏 冠 佩 游 珊 融 满 添 咏 响 珩 杉 韧 梅 乔 同 梦 树 杭 念 遥 苗 胤 榕 耿 崇 湘 里 疆 旻 启 烁 楷 才 仲 隆 媛 晴 章 舰 璟 桔 李 影 亭 珺 言 笛 弛 营 宪 渝 发 逊 运 豹 翊 研 登 炳 蕊 鉴 妍 焰 颂 闻 桢 镭 特 曙 盟 贝 千 保 功 竹 印 玥 夭 冀 阔 圆 湛 澍 争 众 肖 祯 默 珍 煌 余 准 忱 宸 普 韦 舸 创 芸 彭 泰 心 廷 其 业 水 焕 炬 韵 裙 干 唯 轲 陆 陶 将 骋 战 歆 朔 耕 崴 操 幸 向 葵 潜 凤 兰 仪 沙 胡 璋 秦 珑 朗 举 列 蓓 纬 垚 歌 献 或 见 多 谊 迎 州 声 婕 栩 男 衍 洵 犇 颢 照 辛 有 育 甲 禄 起 淮 弋 坦 量 楚 熹 劫 勉 典 诺 溪 显 毓 稳 甫 羿 端 旦 焘 辑 宣 宙 岑 存 迁 万 煦 渤 沁 甜 日 翰 淦 劼 庭 徽 豫 锬 铸 蚵 也 好 颉 雍 怀 北 西 耘 秀 肠 玄 令 蓬 联 斯 霁 朕 箭 坡 澜 馨 瀛 港 岱 宗 闽 励 飙 琥 谷 异 嵬 垣 年 尉 习 格 锨 桑 讳 丛 淞 领 深 赢 宜 律 朴 龚 卉 化 陵 庄 财 墨 直 煊 欧 棋 孝 子 弢 冕 傲 劭 丞 如 燃 铖 畏 崧 汀 弦 墩 溢 崎 容 锁 韩 曼 汽 地 芬 上 佶 连 郑 兆 纪 盾 相 翌 盈 慰 戟 植 晏 任 农 
静 敏 燕 艳 丽 娟 莉 芳 萍 玲 娜 丹 洁 红 颖 琳 霞 婷 慧 莹 晶 华 倩 英 佳 梅 雪 蕾 琴 璐 伟 云 蓉 青 薇 欣 琼 宁 平 媛 虹 杰 婧 雯 茜 楠 洋 君 辉 菲 琦 妍 阳 波 俊 鑫 磊 军 爽 兰 晨 冰 瑶 瑾 岩 瑛 悦 群 玮 欢 瑜 蕊 宇 明 珊 涛 荣 超 琪 玉 怡 文 岚 杨 婕 旭 凤 健 芬 芸 晓 萌 飞 露 菁 惠 宏 瑞 蓓 林 璇 珍 月 利 勤 清 帆 迪 微 斌 娇 影 巍 朋 莎 彬 峰 昕 乐 星 新 烨 晖 卉 晴 曼 越 靖 维 晔 艺 睿 芹 淼 黎 畅 椒 鹏 春 彦 柳 梦 毅 博 妮 坤 翠 然 钰 蔚 曦 茹 凌 扬 凡 美 彤 园 炜 捷 亮 雁 叶 苗 菊 勇 锐 雨 力 翔 庆 方 琰 聪 潇 威 甜 帅 进 琛 花 雅 立 姣 馨 珏 秀 亚 珂 思 哲 冉 骊 双 娅 胡 培 斐 嘉 莲 莺 佩 剑 娴 玥 真 凯 裙 源 奕 靓 侠 枫 洪 姝 敬 希 锦 姗 昱 卓 建 兵 冬 强 卫 香 焱 容 鸣 硕 浩 纯 韵 玫 婵 巧 笑 俐 羽 舒 盼 涵 峥 雷 可 会 航 懿 晗 铭 滢 盈 鸿 茵 灿 程 灵 征 金 琨 江 贞 路 东 煜 圆 贺 一 苹 秋 鹤 珺 南 榕 桦 轶 昊 夏 迎 光 智 臻 恒 景 吉 银 铮 成 松 娣 锋 旋 辰 远 樱 糊 坚 苏 喆 沁 霜 霖 皓 刚 晋 田 筠 珠 元 湘 嫣 卿 蒙 京 泓 媚 跃 隽 泉 赛 弘 妹 婉 原 环 攀 澜 鹰 音 昆 冲 川 芝 娥 贤 昀 野 奇 歌 鸽 竹 璟 苑 诚 滨 萱 霄 嵘 沙 念 汉 岑 桃 骏 谦 安 寅 贝 钦 熙 幸 科 如 沛 意 果 寒 政 柯 芮 鹃 心 海 焕 荔 逸 津 渊 尧 天 震 瓤 溪 炎 研 颜 赞 营 兴 郑 瑗 益 韶 密 歆 易 舟 菡 风 笛 龙 爱 民 唯 乔 丰 康 渝 驰 葡 祯 郁 蕴 延 俏 恬 毓 腾 杉 岭 诺 峻 缨 永 玎 恋 杏 斯 义 俭 漫 正 森 丛 漪 昭 硼 蕙 亭 理 铃 咏 岳 桐 璞 非 祺 放 炯 焰 葵 依 彩 蝶 筱 戈 苓 为 蔷 展 良 想 志 总 耘 淳 泽 好 妤 妙 翼 羚 竞 品 伶 伊 子 烁 鸥 仙 净 格 山 忠 肖 麟 默 齐 润 淑 轩 蔓 葳 皎 西 绮 沫 桢 童 言 禹 涓 严 韬 映 赫 翎 玺 霏 达 宜 钧 蜜 泳 纳 忱 熠 振 碧 素 珉 情 荟 侃 谊 忆 屹 知 旻 珩 秦 飒 赢 或 鹭 霓 韦 桔 荷 吟 仪 励 栋 多 炼 嫒 澄 诗 苇 胜 男 艾 习 弦 茗 育 曝 石 翊 频 蓝 遥 丁 谨 屏 囡 优 顺 鹂 盟 晏 讳 宾 旎 满 游 季 楚 俪 凝 劲 礼 曾 眉 盛 颧 衡 辛 融 骅 啸 氛 杭 李 娉 萃 芊 朗 痴 耀 克 余 响 闻 浪 墩 钥 祥 望 朦 嫚 宝 全 芯 陈 洲 行 钊 昂 学 栩 仁 咪 连 千 冶 旖 姬 晟 肠 稳 霁 恺 桂 茂 台 闽 宪 迅 书 勉 霆 革 箐 砚 端 旦 蝴 颂 垄 垚 桥 溢 骞 裕 玄 粼 颍 颉 殷 胤 妲 菱 也 典 均 缘 梓 旗 煦 赉 飚 灏 郡 玢 键 朝 豫 朔 钢 肪 瑕 勋 刘 前 荃 运 嫱 嵩 牧 来 娓 陶 琚 武 雄 筝 恩 堃 单 含 绚 淋 添 日 殉 孟 尚 照 朵 姿 妃 暖 衍 矫 麒 实 骁 信 茉 郦 劫 汀 瀛 猛 城 争 芄 勃 喜 女 引 获 簧 申 韧 晰 禾 翻 醒 鲲 魏 徽 闪 伦 业 尔 熹 戎 桑 绷 冠 颇 白 韫 璜 珑 颢 颐 策 虎 联 翀 弛 汇 拉 忻 愉 尤 欧 纬 骥 喻 劼 予 翌 繁 珣 慈 豪 彧 允 队 令 若 洵 汝 娆 权 枚 惟 国 滔 奎 尉 夭 闯 俞 鲁
))
