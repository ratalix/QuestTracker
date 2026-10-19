-- QuestTracker : compteur de runs + temps + PB, par épisode
-- Dossier: <PSO>/addons/QuestTracker/init.lua
local core_mainmenu = require("core_mainmenu")

-- Adresses (reprises de Kill Counter)
local ADDR_QUEST_PTR    = 0xA95AA8
local ADDR_DIFFICULTY   = 0xA9CD68
local ADDR_EPISODE      = 0xA9B1C8
local ADDR_LOCATION     = 0xAAFC9C -- +0 = zone (0 = Pioneer 2), +4 = 0xF si lobby
local ADDR_PLAYER_COUNT = 0xAAE168
local ADDR_PLAYER_ARRAY = 0xA94254
local ADDR_MY_INDEX     = 0xA9C4F4

local EP_NAMES   = { [0] = "Episode 1", [1] = "Episode 2", [2] = "Episode 4" }
local DIFF_NAMES = { [0] = "N", [1] = "H", [2] = "VH", [3] = "Ult" }

-- Langue de l'interface : "fr" ou "en" (boutons FR / EN en haut). T() traduit un texte francais.
local LANG = "fr"
local EN = {
    ["Auto : lit le niveau dans le bloc Anguish affiche par le jeu. Sinon reglage manuel."] = "Auto: reads the level from the Anguish block shown by the game. Otherwise set it manually.",
    ["Vider les non valides ?"] = "Clear invalid runs?",
    ["Vider les non valides"] = "Clear invalid runs",
    ["Suivi libre : PB et moyenne meme sans finir la quete"] = "Free tracking: PB and average even if unfinished",
    ["Suivi libre"] = "Free tracking",
    ["Reset des quetes"] = "Reset quests",
    ["Remettre toutes les quetes a 0 ?"] = "Reset all quests to 0?",
    ["Derniere confirmation : compteurs, temps et PB seront effaces. Sur ?"] = "Final confirmation: counters, times and PBs will be erased. Sure?",
    ["Oui, tout effacer"] = "Yes, erase everything",
    ["Quete farm reset"] = "Farm reset quest",
    ["(runs non termines inclus)"] = "(unfinished runs included)",
        ["lu : aucun"] = "read: none",
    ["lu : Ang"] = "read: Ang",
    ["Recherche :"] = "Search :",
    ["Cliquer pour voir les monstres"] = "Click to see the monsters",
    ["abreviation : "] = "abbreviation : ",
    ["Aucune donnee de monstres pour cette quete."] = "No monster data for this quest.",
    ["(fichier quest_monsters.lua introuvable ?)"] = "(quest_monsters.lua file not found?)",
    ["Monstres de la quete"] = "Quest monsters",
    ["Autres"] = "Others",
    ["(aucune quete trouvee)"] = "(no quest found)",
    ["%d runs | %d valides"] = "%d runs | %d valid",
    ["Vider l'historique ?"] = "Clear history?",
    ["Oui"] = "Yes",
    ["Non"] = "No",
    ["Vider l'historique"] = "Clear history",
    ["Quete"] = "Quest",
    ["Difficulte"] = "Difficulty",
    ["Temps"] = "Time",
    ["Valide"] = "Valid",
    ["(aucun run enregistre)"] = "(no run recorded)",
    ["Run valide (quete terminee)"] = "Valid run (quest completed)",
    ["Run non valide : "] = "Invalid run: ",
    ["fin par Retour Lobby"] = "ended by Return to Lobby",
    ["partie quittee / retour lobby (pas de fin de quete detectee)"] = "game left / back to lobby (no quest end detected)",
    ["mort pendant le run (retour a Pioneer 2)"] = "died during the run (back to Pioneer 2)",
    ["autre quete lancee"] = "another quest started",
    ["partie quittee juste apres la fin"] = "game left right after the end",
    ["Verification en cours..."] = "Checking...",
    ["Dernier run : "] = "Last run : ",
    ["Pas encore de PB"] = "No PB yet",
    ["[pause]"] = "[paused]",
    ["Pause du chrono a Pioneer 2"] = "Pause the timer on Pioneer 2",
    ["Par defaut, le temps passe a Pioneer 2 compte dans le chrono (Time Attack). Cocher pour le mettre en pause."] = "By default, time spent on Pioneer 2 counts (Time Attack). Tick to pause the timer there.",
    ["Reglages du timer"] = "Timer settings",
    ["Apercu"] = "Preview",
    ["Afficher le timer pendant une quete"] = "Show the timer during a quest",
    ["Nom de la quete"] = "Quest name",
    ["PB et ecart en direct"] = "PB and live difference",
    ["Chrono vert / orange selon le PB"] = "Green / orange timer depending on PB",
    ["Chrono plus epais"] = "Bolder timer",
       ["Taille du chrono"] = "Timer size",
    ["Opacite du fond (0-100)"] = "Background opacity (0-100)",
    ["Seuls les runs valides (quete rendue) sont comptes ici."] = "Only valid runs (quest handed in) are counted here.",
    ["Runs valides"] = "Valid runs",
    ["Moyenne"] = "Average",
    ["(aucun run valide)"] = "(no valid run)",
    ["Tout"] = "All",
    ["Difficulte :"] = "Difficulty :",
    ["Fin de la quete avec Retour Lobby : ON"] = "End quest on Return to Lobby : ON",
    ["Fin de la quete avec Retour Lobby : OFF"] = "End quest on Return to Lobby : OFF",
    ["Tout remettre a 0 ?"] = "Reset everything to 0?",
    ["Liste de quete"] = "Quest list",
    ["Historique"] = "History",
}
local JA = {
    ["Auto : lit le niveau dans le bloc Anguish affiche par le jeu. Sinon reglage manuel."] = "自動：ゲームが表示するAnguishのレベルを読み取ります。それ以外は手動で設定します。",
    ["Vider les non valides ?"] = "無効な記録を削除しますか？",
    ["Vider les non valides"] = "無効な記録を削除",
    ["Suivi libre : PB et moyenne meme sans finir la quete"] = "フリー計測：クエスト未完了でもPBと平均を記録",
    ["Suivi libre"] = "フリー計測",
    ["Reset des quetes"] = "クエストをリセット",
    ["Remettre toutes les quetes a 0 ?"] = "すべてのクエストを0にリセットしますか？",
    ["Derniere confirmation : compteurs, temps et PB seront effaces. Sur ?"] = "最終確認：回数・タイム・PBがすべて消去されます。よろしいですか？",
    ["Oui, tout effacer"] = "はい、すべて消去",
    ["Quete farm reset"] = "周回リセットクエスト",
    ["(runs non termines inclus)"] = "（未完了の記録を含む）",
    ["lu : aucun"] = "検出：なし",
    ["lu : Ang"] = "検出：アングィッシュ",
    ["Recherche :"] = "検索：",
    ["Cliquer pour voir les monstres"] = "クリックでモンスターを表示",
    ["abreviation : "] = "略称：",
    ["Aucune donnee de monstres pour cette quete."] = "このクエストのモンスターデータはありません。",
    ["(fichier quest_monsters.lua introuvable ?)"] = "（quest_monsters.lua が見つかりません）",
    ["Monstres de la quete"] = "クエストのモンスター",
    ["Autres"] = "その他",
    ["(aucune quete trouvee)"] = "（クエストが見つかりません）",
    ["%d runs | %d valides"] = "%d 回 | 有効 %d",
    ["Vider l'historique ?"] = "履歴を削除しますか？",
    ["Oui"] = "はい",
    ["Non"] = "いいえ",
    ["Vider l'historique"] = "履歴を削除",
    ["Quete"] = "クエスト",
    ["Difficulte"] = "難易度",
    ["Temps"] = "タイム",
    ["Valide"] = "有効",
    ["(aucun run enregistre)"] = "（記録なし）",
    ["Run valide (quete terminee)"] = "有効な記録（クエスト完了）",
    ["Run non valide : "] = "無効な記録：",
    ["fin par Retour Lobby"] = "ロビーへ戻って終了",
    ["partie quittee / retour lobby (pas de fin de quete detectee)"] = "ゲーム退出／ロビー復帰（クエスト完了を検出できず）",
    ["mort pendant le run (retour a Pioneer 2)"] = "ラン中に死亡（パイオニア2へ帰還）",
    ["autre quete lancee"] = "別のクエストを開始",
    ["partie quittee juste apres la fin"] = "終了直後にゲームを退出",
    ["Verification en cours..."] = "確認中...",
    ["Dernier run : "] = "前回のタイム：",
    ["Pas encore de PB"] = "PBなし",
    ["[pause]"] = "[一時停止]",
    ["Pause du chrono a Pioneer 2"] = "ピオニア2でタイマーを一時停止",
    ["Par defaut, le temps passe a Pioneer 2 compte dans le chrono (Time Attack). Cocher pour le mettre en pause."] = "初期設定ではピオニア2での時間もカウント（タイムアタック用）。ONで一時停止します。",
    ["Reglages du timer"] = "タイマー設定",
    ["Apercu"] = "プレビュー",
    ["Afficher le timer pendant une quete"] = "クエスト中にタイマーを表示",
    ["Nom de la quete"] = "クエスト名",
    ["PB et ecart en direct"] = "PBとリアルタイム差",
    ["Chrono vert / orange selon le PB"] = "PBに応じてタイマーを緑／橙に",
    ["Chrono plus epais"] = "タイマーを太字に",
    ["Taille du chrono"] = "タイマーのサイズ",
    ["Opacite du fond (0-100)"] = "背景の不透明度 (0-100)",
    ["Seuls les runs valides (quete rendue) sont comptes ici."] = "ここでは有効な記録（クエスト報告済み）のみ集計します。",
    ["Runs valides"] = "有効回数",
    ["Moyenne"] = "平均",
    ["(aucun run valide)"] = "（有効な記録なし）",
    ["Tout"] = "すべて",
    ["Difficulte :"] = "難易度：",
    ["Fin de la quete avec Retour Lobby : ON"] = "ロビー復帰でクエスト終了：ON",
    ["Fin de la quete avec Retour Lobby : OFF"] = "ロビー復帰でクエスト終了：OFF",
    ["Tout remettre a 0 ?"] = "すべて0にリセットしますか？",
    ["Liste de quete"] = "クエスト一覧",
    ["Historique"] = "履歴",
    ["One Person"] = "ワンパーソン",
    ["Normal"] = "ノーマル",
    ["One Person Mode"] = "ワンパーソンモード",
    ["Normal Mode"] = "ノーマルモード",
    ["Mode :"] = "モード：",
    ["Time Attack / Personal Best"] = "タイムアタック / 自己ベスト",
    ["Timer"] = "タイマー",
    ["Date"] = "日付",
    ["Diff."] = "難易度",
    ["Mode"] = "モード",
    ["No move"] = "移動禁止",
    ["No resize"] = "サイズ変更禁止",
    ["No title bar"] = "タイトルバーなし",
    ["PB"] = "PB",
    ["Reset"] = "リセット",
    ["Anguish"] = "アングィッシュ",
    ["Anguish :"] = "アングィッシュ：",
    ["Auto"] = "自動",
    ["Off"] = "オフ",
    ["Episode 1"] = "エピソード1",
    ["Episode 2"] = "エピソード2",
    ["Episode 4"] = "エピソード4",
    ["Government"] = "政府クエスト",
    ["Side Story"] = "サイドストーリー",
    ["Extermination"] = "殲滅",
    ["Maximum Attack"] = "マキシマムアタック",
    ["Retrieval"] = "回収",
    ["Shop"] = "ショップ",
    ["VR"] = "VR",
    ["Solo Only"] = "ソロ専用",
    ["Event"] = "イベント",
    ["Halloween"] = "ハロウィン",
    ["Sandbox Only"] = "サンドボックス専用",
    ["Tower"] = "タワー",
}
local function T(s)
    if LANG == "ja" then return JA[s] or EN[s] or s end
    if LANG == "en" then return EN[s] or s end
    return s
end
-- T() pour un libelle de bouton "texte##id" : seul le texte visible est traduit
local function Tb(s)
    local a, b = string.match(s, "^(.-)(##.*)$")
    if a then return T(a) .. b end
    return T(s)
end
local SAVE_PATH  = "addons/QuestTracker/data.lua"
local SETTINGS_PATH = "addons/QuestTracker/settings.lua"

-- Noms optionnels : QUEST_NAMES[id] = "Nom"
local QUEST_NAMES = {
    -- [118] = "Exemple",
}

local SECTION_IDS = {
    [0] = "Viridia", [1] = "Greenill", [2] = "Skyly", [3] = "Bluefull",
    [4] = "Purplenum", [5] = "Pinkal", [6] = "Redria", [7] = "Oran",
    [8] = "Yellowboze", [9] = "Whitill",
}
local ADDR_SECTION_ID = 0xA9C4D8
local ADDR_SOLO_FLAG  = 0xA9B1C4 -- 1 = One Person, 0 = Normal (trouvé via ModeFinder)

local open = false -- ferme au lancement du jeu
local confirm_reset = false
local data = {}      -- data[ep][key] = {id, diff, count, best, total, name}
local current = nil  -- run en cours
local last = nil     -- dernier run terminé (en attente de validation)
local history = {}   -- historique des runs, du plus ancien au plus récent
local HISTORY_PATH = "addons/QuestTracker/history.lua"
-- Profil : "normal" ou "sandbox" (deux comptes differents). Chaque profil a ses propres fichiers
-- (data.lua / history.lua pour Normal, data_sandbox.lua / history_sandbox.lua pour Sandbox) :
-- les runs et stats ne se melangent pas. Le profil se choisit avec les boutons en haut de la fenetre.
local PROFILE = "normal"
local switch_profile -- definie plus bas
local function apply_profile_paths()
    if PROFILE == "sandbox" then
        SAVE_PATH = "addons/QuestTracker/data_sandbox.lua"
        HISTORY_PATH = "addons/QuestTracker/history_sandbox.lua"
    else
        SAVE_PATH = "addons/QuestTracker/data.lua"
        HISTORY_PATH = "addons/QuestTracker/history.lua"
    end
end
local HISTORY_MAX = 300           -- nombre de runs gardés dans l'historique
local list_ep = 0                -- sous-onglet de "Liste de quete" : 0 = Ep1, 1 = Ep2, 2 = Ep4
local current_tab = "list"    -- onglet affiché : "counters" ou "history"
local confirm_clear_history = false
-- Suivi libre : quetes dont TOUS les runs (meme non termines) comptent pour un PB / une moyenne a part
local FREE = {}
local FREE_MIN = 20  -- duree minimale (s) d'un run pour compter
local function free_key(name)
    local n = string.lower(tostring(name or "")):gsub("^%d+%-%d+%s*:?%s*", "")
    return (n:gsub("[^%w]", ""))
end
local JAQ = {
    ["addictingfood"] = "病みつきの味",
    ["anewhope"] = "新たなる希望",
    ["anniversarybadgeshop"] = "記念バッジショップ",
    ["anomalousordeal1"] = "異常なる試練 #1",
    ["anomalousordeal2"] = "異常なる試練 #2",
    ["anomalousordeal3"] = "異常なる試練 #3",
    ["anomalousordeal4"] = "異常なる試練 #4",
    ["anomalousordeal5"] = "異常なる試練 #5",
    ["aolcupsunsetbase"] = "AOLカップ -サンセットベース-",
    ["augustatrocity1"] = "8月の惨劇 1",
    ["augustatrocity2"] = "8月の惨劇 2",
    ["battletraining"] = "戦闘訓練",
    ["beachlaughter"] = "浜辺の笑い声",
    ["belowthewaves"] = "波の下に",
    ["beyondthehorizon"] = "地平線の彼方へ",
    ["blackpaper"] = "ブラックペーパー",
    ["blackpapersdangerousdeal"] = "ブラックペーパーの危険な取引",
    ["blackpapersdangerousdeal2"] = "ブラックペーパーの危険な取引 2",
    ["bluestarmemories"] = "青い星の記憶",
    ["buriedrelics"] = "埋もれた遺物",
    ["calsclockchallenge"] = "CALの時計チャレンジ",
    ["centralcontrol"] = "中央制御室",
    ["centraldomefireswirl"] = "セントラルドームの炎渦",
    ["christmaseventshop"] = "クリスマスイベントショップ",
    ["christmasfiasco"] = "クリスマス大騒動",
    ["chronocidetrial1"] = "時間殺しの試練 #1",
    ["chronocidetrial2"] = "時間殺しの試練 #2",
    ["chronocidetrial3"] = "時間殺しの試練 #3",
    ["chronocidetrial4"] = "時間殺しの試練 #4",
    ["claimingastake"] = "権利の主張",
    ["clairesdeal5"] = "クレアの取引 5",
    ["darkinheritance"] = "闇の継承",
    ["dataretrieval"] = "データ回収",
    ["decemberdisaster1"] = "12月の災難 #1",
    ["decemberdisaster2"] = "12月の災難 #2",
    ["deepwithin"] = "奥地へ",
    ["desiresend"] = "欲望の果て",
    ["docssecretplan"] = "ドクの秘密計画",
    ["dolmolmresearch"] = "ドルモルム調査",
    ["dreammessenger"] = "夢の使者",
    ["drostosresearch"] = "オスト博士の研究",
    ["endlessepisode1"] = "エンドレス: エピソード1",
    ["endlessepisode2"] = "エンドレス: エピソード2",
    ["endlessnightmare1"] = "終わらない悪夢 #1",
    ["endlessnightmare2"] = "終わらない悪夢 #2",
    ["endlessnightmare3"] = "終わらない悪夢 #3",
    ["endlessnightmare4"] = "終わらない悪夢 #4",
    ["festivityonthebeach"] = "浜辺の祝祭",
    ["forestofsorrow"] = "悲しみの森",
    ["forsakenfriends"] = "見捨てられた友",
    ["fragmentsofamemory"] = "記憶の断片",
    ["fromthedepths"] = "深淵より",
    ["fromthepast"] = "過去からの使者",
    ["galdavalsdarkness"] = "ギャルダバルの闇",
    ["gallonsplan"] = "ギャロンの計画",
    ["gallonsshop"] = "ギャロンの店",
    ["gallonstreachery"] = "ギャロンの裏切り",
    ["goodluck"] = "グッドラック！",
    ["gransquall"] = "グランスコール",
    ["herodaughter"] = "英雄と娘",
    ["hollowbattlefieldcave"] = "虚ろな戦場：洞窟",
    ["hollowbattlefieldforest"] = "虚ろな戦場：森",
    ["hollowbattlefieldmine"] = "虚ろな戦場：坑道",
    ["hollowbattlefieldruins"] = "虚ろな戦場：遺跡",
    ["hollowphantasmjungle"] = "虚ろな幻影：ジャングル",
    ["hollowphantasmseabed"] = "虚ろな幻影：海底",
    ["hollowphantasmtower"] = "虚ろな幻影：タワー",
    ["hollowrealityspaceship"] = "虚ろな現実：スペースシップ",
    ["hollowrealitytemple"] = "虚ろな現実：テンプル",
    ["hollowwastelanddesert"] = "虚ろな荒野：砂漠",
    ["hollowwastelandwilderness"] = "虚ろな荒野：荒野",
    ["infernalcavern"] = "灼熱の洞窟",
    ["isleofmutants"] = "ミュータントの島",
    ["itempresent"] = "アイテムプレゼント",
    ["journalisticpursuit"] = "記者の追跡",
    ["knightofcoral"] = "コーラルの騎士",
    ["knightofcoraladvent"] = "コーラルの騎士 降臨",
    ["knowingonesheart"] = "心を知る",
    ["labyrinthinetrial"] = "迷宮の試練",
    ["letterfromlionel"] = "ライオネルからの手紙",
    ["lostberserkbaton"] = "ロスト BERSERK BATON",
    ["lostbindassault"] = "ロスト BIND ASSAULT",
    ["lostchargevulcan"] = "ロスト CHARGE VULCAN",
    ["lostdemonsrailgun"] = "ロスト DEMON'S RAILGUN",
    ["lostfillcannon"] = "ロスト FILL CANNON",
    ["lostheatsword"] = "ロスト HEAT SWORD",
    ["losthellpallasch"] = "ロスト HELL PALLASCH",
    ["losticespinner"] = "ロスト ICE SPINNER",
    ["lostshockrifle"] = "ロスト SHOCK RIFLE",
    ["lostsonjim"] = "行方不明の息子ジム",
    ["lostsoulblade"] = "ロスト SOUL BLADE",
    ["lostspiritstriker"] = "ロスト SPIRIT STRIKER",
    ["machinesattack"] = "機械の襲撃",
    ["magnitudeofmetal"] = "鋼鉄の威力",
    ["maximumattack1ver2"] = "マキシマムアタック 1 Ver2",
    ["maximumattack2ver2"] = "マキシマムアタック 2 Ver2",
    ["maximumattack3ver2"] = "マキシマムアタック 3 Ver2",
    ["maximumattack4thstage1a"] = "マキシマムアタック 4thステージ -1A-",
    ["maximumattack4thstage1b"] = "マキシマムアタック 4thステージ -1B-",
    ["maximumattack4thstage1c"] = "マキシマムアタック 4thステージ -1C-",
    ["maximumattack4thstage1r"] = "マキシマムアタック 4thステージ -1R-",
    ["maximumattack4thstage2a"] = "マキシマムアタック 4thステージ -2A-",
    ["maximumattack4thstage2b"] = "マキシマムアタック 4thステージ -2B-",
    ["maximumattack4thstage2c"] = "マキシマムアタック 4thステージ -2C-",
    ["maximumattack4thstage2r"] = "マキシマムアタック 4thステージ -2R-",
    ["maximumattack4thstage4a"] = "マキシマムアタック 4thステージ -4A-",
    ["maximumattack4thstage4b"] = "マキシマムアタック 4thステージ -4B-",
    ["maximumattack4thstage4c"] = "マキシマムアタック 4thステージ -4C-",
    ["maximumattack4thstage4r"] = "マキシマムアタック 4thステージ -4R-",
    ["maximumattackecave"] = "マキシマムアタック E: 洞窟",
    ["maximumattackecca"] = "マキシマムアタック E: CCA",
    ["maximumattackecrater"] = "マキシマムアタック E: クレーター",
    ["maximumattackedesert"] = "マキシマムアタック E: 砂漠",
    ["maximumattackeepisode1"] = "マキシマムアタック E: エピソード1",
    ["maximumattackeepisode4"] = "マキシマムアタック E: エピソード4",
    ["maximumattackeforest"] = "マキシマムアタック E: 森",
    ["maximumattackegaldaval"] = "マキシマムアタック E: ギャルダバル",
    ["maximumattackemine"] = "マキシマムアタック E: 坑道",
    ["maximumattackeruins"] = "マキシマムアタック E: 遺跡",
    ["maximumattackeseabed"] = "マキシマムアタック E: 海底",
    ["maximumattackespaceship"] = "マキシマムアタック E: スペースシップ",
    ["maximumattacketemple"] = "マキシマムアタック E: テンプル",
    ["maximumattacketower"] = "マキシマムアタック E: タワー",
    ["maximumattackevr"] = "マキシマムアタック E: VR",
    ["mineoffensive"] = "マインオフェンシブ",
    ["missingresearch"] = "消えた研究",
    ["mopupoperation1"] = "掃討作戦 #1",
    ["mopupoperation2"] = "掃討作戦 #2",
    ["mopupoperation3"] = "掃討作戦 #3",
    ["mopupoperation4"] = "掃討作戦 #4",
    ["mycareer"] = "マイキャリア",
    ["nativeresearch"] = "原生生物の調査",
    ["newmopupoperation1"] = "新・掃討作戦 #1",
    ["newmopupoperation2"] = "新・掃討作戦 #2",
    ["newmopupoperation3"] = "新・掃討作戦 #3",
    ["newmopupoperation4"] = "新・掃討作戦 #4",
    ["newmopupoperation5"] = "新・掃討作戦 #5",
    ["penumbralsurge1"] = "半影の奔流 #1",
    ["penumbralsurge2"] = "半影の奔流 #2",
    ["penumbralsurge3"] = "半影の奔流 #3",
    ["penumbralsurge4"] = "半影の奔流 #4",
    ["penumbralsurge5"] = "半影の奔流 #5",
    ["penumbralsurge6"] = "半影の奔流 #6",
    ["phantasmalworld1"] = "幻影の世界 #1",
    ["phantasmalworld2"] = "幻影の世界 #2",
    ["phantasmalworld3"] = "幻影の世界 #3",
    ["phantasmalworld4"] = "幻影の世界 #4",
    ["pioneerchristmas"] = "パイオニア・クリスマス",
    ["pioneerhalloween"] = "パイオニア・ハロウィン",
    ["pioneerspirit"] = "開拓者精神",
    ["planetragol"] = "惑星ラグオル",
    ["pointofdisaster"] = "災厄の地点",
    ["purplelamplight"] = "紫の灯火",
    ["pursuit"] = "追跡",
    ["raidoncentraltower"] = "セントラルタワー襲撃",
    ["randomattackxrdrev1"] = "ランダムアタック Xrd REV 1",
    ["randomattackxrdrev2"] = "ランダムアタック Xrd REV 2",
    ["randomattackxrdrev4"] = "ランダムアタック Xrd REV 4",
    ["randomattackxrdstage"] = "ランダムアタック Xrd ステージ",
    ["rappyhalloween"] = "ラッピー・ハロウィン",
    ["rappysholiday"] = "ラッピーの休日",
    ["reachforthedream"] = "夢に手を伸ばして",
    ["realitytruth"] = "現実と真実",
    ["rescuefromragol"] = "ラグオルからの救出",
    ["respectivetomorrow"] = "それぞれの明日",
    ["revisitingdarkness"] = "再訪する闇",
    ["roadtonowhere"] = "どこにも続かない道",
    ["ruinswreckage"] = "遺跡の残骸",
    ["sacredground"] = "聖なる地",
    ["scarletrealm1"] = "緋色の領域 #1",
    ["scarletrealm2"] = "緋色の領域 #2",
    ["scarletrealm3"] = "緋色の領域 #3",
    ["scarletrealm4"] = "緋色の領域 #4",
    ["seasonsshop"] = "シーズンショップ",
    ["seatoftheheart"] = "心の座",
    ["secretdelivery"] = "秘密の配達",
    ["seekingclues"] = "手がかりを求めて",
    ["seekmymaster"] = "主を探して",
    ["silentafterimage1"] = "静寂の残像 #1",
    ["silentafterimage2"] = "静寂の残像 #2",
    ["silentbeach"] = "静かなる浜辺",
    ["simulator20"] = "シミュレーター 2.0",
    ["singingbythebeach"] = "浜辺の歌",
    ["solsticesnafu"] = "至点の混乱",
    ["soulofablacksmith"] = "鍛冶屋の魂",
    ["soulofsteel"] = "鋼の魂",
    ["subterraneanden"] = "地下の巣窟",
    ["subterraneanpatrol1"] = "地下パトロール #1",
    ["subterraneanpatrol2"] = "地下パトロール #2",
    ["subterraneanpatrol3"] = "地下パトロール #3",
    ["sugoroku"] = "すごろく",
    ["sweepupoperation1"] = "殲滅作戦 #1",
    ["sweepupoperation10"] = "殲滅作戦 #10",
    ["sweepupoperation11"] = "殲滅作戦 #11",
    ["sweepupoperation12"] = "殲滅作戦 #12",
    ["sweepupoperation13"] = "殲滅作戦 #13",
    ["sweepupoperation14"] = "殲滅作戦 #14",
    ["sweepupoperation2"] = "殲滅作戦 #2",
    ["sweepupoperation3"] = "殲滅作戦 #3",
    ["sweepupoperation4"] = "殲滅作戦 #4",
    ["sweepupoperation5"] = "殲滅作戦 #5",
    ["sweepupoperation6"] = "殲滅作戦 #6",
    ["sweepupoperation7"] = "殲滅作戦 #7",
    ["sweepupoperation8"] = "殲滅作戦 #8",
    ["sweepupoperation9"] = "殲滅作戦 #9",
    ["tarewardshop"] = "TA報酬ショップ",
    ["testspaceship1"] = "テスト/スペースシップ 1",
    ["testspaceship2"] = "テスト/スペースシップ 2",
    ["testspaceship3"] = "テスト/スペースシップ 3",
    ["testspaceship4"] = "テスト/スペースシップ 4",
    ["testspaceship5"] = "テスト/スペースシップ 5",
    ["testvrtemple1"] = "テスト/VRテンプル 1",
    ["testvrtemple2"] = "テスト/VRテンプル 2",
    ["testvrtemple3"] = "テスト/VRテンプル 3",
    ["testvrtemple4"] = "テスト/VRテンプル 4",
    ["testvrtemple5"] = "テスト/VRテンプル 5",
    ["thebeakscafever2"] = "ビークスカフェ Ver.2",
    ["thechosen12"] = "選ばれし者 (1/2)",
    ["thechosen22"] = "選ばれし者 (2/2)",
    ["theeasttower"] = "東の塔",
    ["theeggshop"] = "タマゴショップ",
    ["thefacility"] = "研究施設",
    ["thefakeinyellow"] = "黄色い偽物",
    ["thefinalcycle"] = "最後の周期",
    ["theforge"] = "鍛冶場",
    ["thegloomspire"] = "薄暗き尖塔",
    ["thegravesbutler"] = "墓守の執事",
    ["thelostbride"] = "消えた花嫁",
    ["thelostruins"] = "失われた遺跡",
    ["themilitarystrikesback"] = "軍の逆襲",
    ["themissingmaracas"] = "消えたマラカス",
    ["themutation"] = "突然変異",
    ["therestlesslion"] = "眠れぬ獅子",
    ["theretiredhunter"] = "引退したハンター",
    ["therobotsreckoning"] = "ロボットの清算",
    ["thetombstirs"] = "目覚める墓所",
    ["thevalueofmoney"] = "お金の価値",
    ["thewesttower"] = "西の塔",
    ["thismustbetheplace"] = "ここがその場所",
    ["todaysrate"] = "本日のレート",
    ["torrentialwoods"] = "豪雨の森",
    ["tothedeepestbluema4venue"] = "最も深い青へ -MA4会場-",
    ["towardsthefuture"] = "未来へ向けて",
    ["twilightsanctuary"] = "黄昏の聖域",
    ["tyrellsego"] = "タイレルのエゴ",
    ["underworldpatrol1"] = "冥界パトロール #1",
    ["unsealeddoor"] = "解かれた扉",
    ["virtuallimits1"] = "仮想の限界 1",
    ["virtuallimits2"] = "仮想の限界 2",
    ["virtualvortex1"] = "仮想の渦 1",
    ["virtualvortex2"] = "仮想の渦 2",
    ["waroflimits1"] = "限界の戦争 #1",
    ["waroflimits2"] = "限界の戦争 #2",
    ["waroflimits3"] = "限界の戦争 #3",
    ["waroflimits4"] = "限界の戦争 #4",
    ["waroflimits5"] = "限界の戦争 #5",
    ["warriorspride"] = "戦士の誇り",
    ["waterfalltears"] = "滝の涙",
    ["waterwayshadow"] = "水路の影",
}
-- Nom de quete affiche : traduit en japonais si la langue est "ja" (sinon le nom d'origine)
local function QN(name)
    if LANG ~= "ja" then return name end
    local v = JAQ[free_key(name)]
    if not v then return name end
    return (string.match(tostring(name), "^%d+%-%d+%s*:%s*") or "") .. v
end
local no_title = false
-- Reglages du timer (onglet Timer)
local TM = {
    enabled = true,   -- afficher le timer pendant une quete
    name = true,      -- nom de la quete
    pb = true,        -- ligne PB + ecart
    colors = true,    -- chrono vert / orange selon le PB
    bold = true,      -- chrono plus epais
    no_move = false,  -- verrouiller la position
    no_resize = true, -- verrouiller la taille
    p2_pause = false, -- option : pause du chrono a Pioneer 2 (desactivee par defaut : le temps a Pioneer 2 compte)
    scale = 1.6,      -- taille du chrono
    alpha = 0,        -- opacite du fond (0-100)
}
local ANG_MAX = 3        -- Anguish : 3 niveaux (Ang1 a Ang3)
local ang_auto = true   -- Anguish lu automatiquement dans le texte affiche par le jeu
local ANG_BUF = 0x10CDC2BE  -- texte "Anguish N" du bloc affiche par le jeu (UTF-16)
local ang_level = 0      -- Anguish actif : 0 = aucun, 1..3 (a regler a la main avec le menu "Anguish")
local function run_key(id, diff, mode, ang)
    return id .. "_" .. diff .. "_" .. mode .. ((ang or 0) > 0 and ("_a" .. ang) or "")
end
local mode_pref = "auto"   -- "auto", "solo" (One Person) ou "normal"
local MODE_NAMES = { solo = "One Person", normal = "Normal" }
local MODE_ORDER = { "solo", "normal" }

------------------------------------------------------------
-- Sauvegarde / chargement
------------------------------------------------------------
local function save()
    local f = io.open(SAVE_PATH, "w+")
    if not f then return end
    f:write("return {\n")
    for ep, quests in pairs(data) do
        f:write(string.format("[%d]={\n", ep))
        for key, q in pairs(quests) do
            f:write(string.format("[%q]={id=%d,diff=%d,count=%d,best=%s,total=%d,name=%q,mode=%q,done=%d,dtotal=%d,vbest=%s,ang=%d,fcount=%d,ftotal=%d,fbest=%s},\n",
                key, q.id, q.diff, q.count, q.best and tostring(q.best) or "nil", q.total, q.name,
                q.mode or "normal", q.done or 0, q.dtotal or 0, q.vbest and tostring(q.vbest) or "nil", q.ang or 0,
                q.fcount or 0, q.ftotal or 0, q.fbest and tostring(q.fbest) or "nil"))
        end
        f:write("},\n")
    end
    f:write("}\n")
    f:close()
end

local function load_data()
    local chunk = loadfile(SAVE_PATH)
    if chunk then
        local ok, t = pcall(chunk)
        if ok and type(t) == "table" then
            data = t
            -- Migration : anciennes entrées sans mode = "normal"
            for ep, quests in pairs(data) do
                local fixed = {}
                for _, q in pairs(quests) do
                    q.mode = q.mode or "normal"
                    q.done = q.done or 0
                    q.ang = q.ang or 0
                    fixed[run_key(q.id, q.diff, q.mode, q.ang)] = q
                end
                data[ep] = fixed
            end
        end
    end
end

local function save_history()
    local f = io.open(HISTORY_PATH, "w+")
    if not f then return end
    f:write("return {\n")
    for _, h in ipairs(history) do
        f:write(string.format("{at=%d,ep=%d,diff=%d,mode=%q,name=%q,dur=%d,ok=%s,why=%q,ang=%d},\n",
            h.at, h.ep, h.diff, h.mode or "normal", h.name, h.dur,
            h.ok == nil and "nil" or tostring(h.ok), h.why or "", h.ang or 0))
    end
    f:write("}\n")
    f:close()
end

local function load_history()
    local chunk = loadfile(HISTORY_PATH)
    if not chunk then return end
    local ok, t = pcall(chunk)
    if not (ok and type(t) == "table") then return end
    for _, h in ipairs(t) do
        if type(h) == "table" and h.at and h.name and h.dur then
            -- un run dont la verification n'a jamais abouti (jeu ferme) n'est pas valide
            if h.ok == nil then h.ok = false end
            if h.why == "" then h.why = nil end
            h.ep = h.ep or 0
            h.diff = h.diff or 0
            h.ang = h.ang or 0
            table.insert(history, h)
        end
    end
end

-- Niveau lu dans le texte "Anguish N" que le jeu affiche (nil si absent)
local ANGS = { cand = {}, pos = 0x10000000, stop = 0x14000000, hits = {}, wait = 0, cur = nil }
local ANG_PAT = "A\0n\0g\0u\0i\0s\0h\0 \0"

-- Valeur de "Anguish N" a une adresse (nil si absent). Seul le message de creation de partie compte.
local function ang_at(addr)
    local ok, s = pcall(pso.read_wstr, addr, 16)
    if ok and type(s) == "string" then
        local n = string.match(s, "^Anguish (%d+)")
        if n then return tonumber(n) end
    end
    return nil
end

-- Adresses connues d'une session precedente : lecture immediate des le lancement
do
    local f = io.open("addons/QuestTracker/ang_scan.txt", "r")
    if f then
        for line in f:lines() do
            local hx = string.match(line, "^0x(%x+)%s+Anguish %d")
            if hx then ANGS.cand[tonumber(hx, 16)] = false end
        end
        f:close()
    end
    ANGS.cand[ANG_BUF] = false
end

-- Recherche progressive (quelques Mo par image) des textes "Anguish N" dans la memoire du jeu
local function ang_scan_step()
    if ANGS.wait > 0 then ANGS.wait = ANGS.wait - 1 return end
    for _ = 1, 192 do
        local a = ANGS.pos
        if a >= ANGS.stop then
            local set = {}
            for _, h in ipairs(ANGS.hits) do set[h.addr] = true end
            local f = io.open("addons/QuestTracker/ang_scan.txt", "w+")
            if f then f:write(os.date("%H:%M:%S") .. " hits=" .. #ANGS.hits .. "\n") end
            for _, h in ipairs(ANGS.hits) do
                -- les listes fixes du jeu (Anguish 1..10 espaces de 0x20) sont ignorees
                local static = set[h.addr + 0x20] or set[h.addr - 0x20]
                if not static then
                    if f then f:write(string.format("0x%08X  %s\n", h.addr, h.txt)) end
                    if ANGS.cand[h.addr] == nil then
                        ANGS.cand[h.addr] = h.val
                        ANGS.cur = h.val
                    end
                end
            end
            if f then f:close() end
            ANGS.hits = {}
            ANGS.pos = 0x10000000
            ANGS.wait = 20
            return
        end
        ANGS.pos = a + 4096
        local ok, s = pcall(pso.read_mem_str, a, 4096)
        if ok and type(s) == "string" then
            local i = 1
            while true do
                local p = string.find(s, ANG_PAT, i, true)
                if not p then break end
                local addr = a + p - 1
                local v = ang_at(addr)
                if v and #ANGS.hits < 60 then
                    local _, t = pcall(pso.read_wstr, addr, 16)
                    ANGS.hits[#ANGS.hits + 1] = { addr = addr, val = v, txt = tostring(t) }
                end
                i = p + 2
            end
        end
    end
end

-- Niveau courant : la valeur du buffer qui a change le plus recemment
local function ang_read()
    local any = false
    for ad, prev in pairs(ANGS.cand) do
        local v = ang_at(ad)
        if v then
            any = true
            if prev ~= v then
                ANGS.cand[ad] = v
                ANGS.cur = v
            end
        elseif prev then
            ANGS.cand[ad] = false
        end
    end
    pcall(ang_scan_step)
    return ANGS.cur
end

local function ang_current()
    if ang_auto then return ang_read() or 0 end
    return ang_level
end

local function save_settings()
    local f = io.open(SETTINGS_PATH, "w+")
    if not f then return end
    local fl = {}
    for k, v in pairs(FREE) do
        if v then fl[#fl + 1] = string.format("[%q] = true", k) end
    end
    table.sort(fl)
    f:write(string.format("return { no_title = %s, mode_pref = %q, profile = %q, ang_level = %d, ang_auto = %s, lang = %q, tm = { enabled = %s, name = %s, pb = %s, colors = %s, bold = %s, no_move = %s, no_resize = %s, p2_pause = %s, scale = %.1f, alpha = %d }, free = { %s } }\n",
        tostring(no_title), mode_pref, PROFILE, ang_level, tostring(ang_auto), LANG,
        tostring(TM.enabled), tostring(TM.name), tostring(TM.pb), tostring(TM.colors), tostring(TM.bold),
        tostring(TM.no_move), tostring(TM.no_resize), tostring(TM.p2_pause), TM.scale, TM.alpha, table.concat(fl, ", ")))
    f:close()
end

local function load_settings()
    local chunk = loadfile(SETTINGS_PATH)
    if chunk then
        local ok, t = pcall(chunk)
        if ok and type(t) == "table" then
            no_title = t.no_title == true
            if t.profile == "sandbox" then PROFILE = "sandbox" end
            apply_profile_paths()
            if t.ang_auto == false then ang_auto = false end
            if t.lang == "en" or t.lang == "fr" or t.lang == "ja" then LANG = t.lang end
            if type(t.tm) == "table" then
                for k, v in pairs(TM) do
                    if type(t.tm[k]) == type(v) then TM[k] = t.tm[k] end
                end
            end
            if type(t.free) == "table" then
                for k, v in pairs(t.free) do
                    if v == true and type(k) == "string" then FREE[k] = true end
                end
            end
            if type(t.ang_level) == "number" and t.ang_level >= 0 and t.ang_level <= ANG_MAX then
                ang_level = math.floor(t.ang_level)
            end
            mode_pref = "auto" -- le mode (One Person / Normal) est toujours detecte automatiquement
        end
    end
end

------------------------------------------------------------
-- Lecture mémoire
------------------------------------------------------------
local function get_quest_id()
    local ptr = pso.read_u32(ADDR_QUEST_PTR)
    if ptr == 0 then return 0 end
    local qd = pso.read_u32(ptr + 0x19C)
    if qd == 0 then return 0 end
    return pso.read_u32(qd + 0x10)
end

-- Le nom de la quête est dans l'en-tête du .bin (UTF-16, offset 0x18,
-- 32 caractères), au même endroit que l'ID lu à +0x10.
local function get_quest_name(id)
    if QUEST_NAMES[id] then return QUEST_NAMES[id] end
    local ptr = pso.read_u32(ADDR_QUEST_PTR)
    if ptr ~= 0 then
        local qd = pso.read_u32(ptr + 0x19C)
        if qd ~= 0 then
            local ok, name = pcall(pso.read_wstr, qd + 0x18, 32)
            if ok and type(name) == "string" and #name > 0
               and not name:find("[%z\1-\31]") then
                return name
            end
        end
    end
    return "Quest " .. id
end

-- Fin de quete par registre ou interrupteur d'etage (comme psostats) : le script de la quete met un
-- registre a une valeur > 0 quand l'objectif est rempli. quest_registers.lua donne, par numero de quete,
-- la condition de fin.
-- Les registres sont a (pointeur de quete + 0x2C) -> adresse + 4 * numero. Le texte reste en secours.
local REGS = { map = {} }
do
    local ok, chunk = pcall(loadfile, "addons/QuestTracker/quest_registers.lua")
    if ok and chunk then
        local ok2, t = pcall(chunk)
        if ok2 and type(t) == "table" then REGS.map = t end
    end
end
-- true / false : etat de la condition de fin (registre ou interrupteur d'etage) ; nil : quete
-- sans condition connue ou lecture impossible
function REGS.cond_set(cond)
    if not cond then return nil end
    local ok, v = pcall(function()
        if type(cond) == "table" then
            -- interrupteurs d'etage : 32 octets par etage a 0xAC9FA0, lus par mots de 16 bits
            local sw = cond.switch
            local w = pso.read_u16(0xAC9FA0 + 32 * cond.floor + 2 * math.floor(sw / 16))
            local m = (sw % 16 >= 8) and (0x8000 / 2 ^ (sw % 8)) or (0x80 / 2 ^ (sw % 8))
            return (math.floor(w / m) % 2 == 1) and 1 or 0
        end
        local ptr = pso.read_u32(ADDR_QUEST_PTR)
        if ptr == 0 then return nil end
        local rp = pso.read_u32(ptr + 0x2C)
        if rp == 0 then return nil end
        return pso.read_u16(rp + 4 * cond)
    end)
    if not ok or v == nil then return nil end
    return v > 0
end
function REGS.is_set(qid) return REGS.cond_set(REGS.map[qid]) end

-- Debut de quete (quest_starts.lua, extrait de psostats) : registre, interrupteur d'etage ou "warp"
-- (arrivee sur le terrain). Sans entree, le chrono demarre quand la quete est prise au comptoir.
local STARTS = { map = {} }
do
    local ok, chunk = pcall(loadfile, "addons/QuestTracker/quest_starts.lua")
    if ok and chunk then
        local ok2, t = pcall(chunk)
        if ok2 and type(t) == "table" then STARTS.map = t end
    end
end

local function resolve_mode()
    if mode_pref ~= "auto" then return mode_pref end
    return (pso.read_u32(ADDR_SOLO_FLAG) == 1) and "solo" or "normal"
end

------------------------------------------------------------
-- Suivi des runs
------------------------------------------------------------

-- Le run est compté (count + temps) dès qu'il se termine ; il est validé (PB, moyenne)
-- automatiquement quand la fin de quête est détectée (registre de la quête, sinon texte du jeu).
-- Coche "run valide" : seulement si la quete est dechargee par le jeu alors qu'on reste
-- en partie (verifie pendant COMPLETE_CHECK_SECONDS). Retourner a Pioneer 2, faire
-- "lobby" ou quitter la partie ne valide JAMAIS un run. reason (pourquoi le run s'arrete) :
--   "quest"    : quete dechargee alors qu'on est reste en jeu (seul cas pouvant etre valide)
--   "p2"       : fin par l'option "Retour Lobby" (retour Pioneer 2)  -> pas de coche
--   "left"     : partie quittee / retour lobby                       -> pas de coche
--   "switched" : une autre quete a pris la place                     -> pas de coche
local COMPLETE_CHECK_SECONDS = 2

------------------------------------------------------------
-- Lecture du texte de dialogue (utilise seulement par le diagnostic)
------------------------------------------------------------
local DIALOG_ADDR  = 0xA94B80
local DIALOG_CHARS = 0x60

local function read_dialog_text()
    local ok, text = pcall(pso.read_wstr, DIALOG_ADDR, DIALOG_CHARS)
    if ok and type(text) == "string" then
        return (text:gsub("[%z\1-\31]", " "))
    end
    return ""
end

-- Message de fin de quete affiche par le jeu (texte du client, pas du script de la quete) :
-- "You will be taken to the lobby after you receive your reward."
-- Il apparait avant d'arriver a Pioneer 2. Un retour par telepipe ne l'affiche pas.
-- Phrases integrees (une par type de fin de quete connu) :
--   Mop-up Operation et quetes similaires : "taken to the lobby"
--   Simulator 2.0                         : "cleared simulation"
-- Pour ajouter d'autres quetes sans toucher au code : ecris une phrase par ligne (en
-- minuscules, un morceau du texte suffit) dans addons/QuestTracker/fin_quete.txt.
local COMPLETION_PHRASES = {
    "taken to the lobby", "your reward", "cleared simulation",
}
-- Messages de recompense du comptoir (Simulator : "You got ... Meseta", quetes event :
-- "You've been awarded ... meseta"). Pris en compte seulement a Pioneer 2 (hors zone
-- de combat), pour ne pas confondre avec un texte de quete qui parle de meseta.
local REWARD_PHRASES = { "meseta", "awarded" }
local PHRASES_PATH = "addons/QuestTracker/fin_quete.txt"

local function load_phrases()
    local f = io.open(PHRASES_PATH, "r")
    if not f then return end
    for line in f:lines() do
        line = line:gsub("\r", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if #line > 2 and line:sub(1, 1) ~= "#" then
            COMPLETION_PHRASES[#COMPLETION_PHRASES + 1] = line:lower()
        end
    end
    f:close()
end

local function is_completion_text(text, in_area)
    local low = text:lower()
    for _, phrase in ipairs(COMPLETION_PHRASES) do
        if low:find(phrase, 1, true) then return true end
    end
    if not in_area then
        for _, phrase in ipairs(REWARD_PHRASES) do
            if low:find(phrase, 1, true) then return true end
        end
    end
    return false
end

-- Texte gris affiche quand il n'y a pas de coche (pour comprendre pourquoi)
local WHY_TEXT = {
    p2 = "fin par Retour Lobby",
    left = "partie quittee / retour lobby (pas de fin de quete detectee)",
    died = "mort pendant le run (retour a Pioneer 2)",
    switched = "autre quete lancee",
    left_fast = "partie quittee juste apres la fin",
}

-- Time Attack : seuls les runs valides (quete rendue) comptent pour le PB et la moyenne
local function credit_validated(q, dur)
    q.done = (q.done or 0) + 1
    q.dtotal = (q.dtotal or 0) + dur
    if not q.vbest or dur < q.vbest then q.vbest = dur end
end

-- Etages de Pioneer 2 (releves dans les logs : EP1 = 0, EP2 = 18, EP4 = 45). Sert au depart automatique
-- et a la pause : on ne se base PAS sur la liste des zones de combat, car certaines zones de quete
-- (arenes de boss VR...) n'y sont pas.
local P2_FLOORS = { [0] = true, [18] = true, [45] = true }

-- Journal de debug (addons/QuestTracker/debug_log.txt) : evenements du suivi de run uniquement.
local DEBUG_LOG = false -- mettre true pour ecrire addons/QuestTracker/debug_log.txt (diagnostic)
local function dbg(msg)
    if not DEBUG_LOG then return end
    local f = io.open("addons/QuestTracker/debug_log.txt", "a")
    if f then
        f:write(os.date("%H:%M:%S") .. "  " .. msg .. "\n")
        f:close()
    end
end

dbg("=== QuestTracker charge - build 4 (run garde si lobby=true et meme quete) ===")

-- Temps ecoule d'un run, sans les passages a Pioneer 2 (pause) une fois sorti pour la premiere fois
local function run_elapsed(run)
    local t = run.stop_at or os.time()
    local paused = run.paused or 0
    if run.pause_since then paused = paused + math.max(0, t - run.pause_since) end
    return t - run.start - paused
end

local function end_run(reason)
    if not current then return end
    local run = current
    dbg(string.format("FIN run id=%s raison=%s finished=%s wait_start=%s dur=%s", tostring(run.id), tostring(reason),
        tostring(run.finished), tostring(run.wait_start), tostring(os.time() - run.start)))
    current = nil
    -- debut jamais detecte (ex. quete quittee avant le terrain) : on retombe sur la prise au comptoir
    if run.wait_start then run.start = run.load_at or run.start; run.wait_start = false end
    -- Filet de securite : si on est parti si vite que le message de fin n'a pas ete vu, on relit une
    -- derniere fois le texte (le message peut rester en memoire un instant apres le depart)
    if not run.finished and run.text_clear and not run.dead and is_completion_text(read_dialog_text(), true) then
        run.finished = true
        run.stop_at = os.time()
    end
    -- Quete gouvernementale : dialogue de fin vu a Pioneer 2 (au moins 2 lignes) puis depart du jeu
    -- dans les 7 s qui suivent (le jeu renvoie au lobby ~6 s apres la derniere ligne) = quete rendue.
    -- Le temps s'arrete a la derniere ligne de dialogue.
    if run.gov and not run.finished and not run.dead and (reason == "left" or reason == "quest")
       and (run.p2_n or 0) >= 2 and os.time() - (run.p2_at or 0) <= 7 then
        run.finished = true
        run.stop_at = run.p2_at
    end
    -- le chrono s'arrete au moment ou la fin de quete a ete detectee
    local dur = run_elapsed(run)
    -- on enregistre sans PB, puis le bouton "Terminée" peut ajouter le PB
    data[run.ep] = data[run.ep] or {}
    local key = run_key(run.id, run.diff, run.mode, run.ang)
    local q = data[run.ep][key] or {
        id = run.id, diff = run.diff, count = 0, total = 0,
        name = run.name, mode = run.mode, ang = run.ang or 0,
    }
    q.name = run.name -- met à jour les anciens "Quest N"
    q.count = q.count + 1
    q.total = q.total + dur
    -- suivi libre : tous les runs (meme non termines) comptent a part, sans toucher aux runs valides
    if FREE[free_key(run.name)] and dur >= FREE_MIN and not run.dead then
        q.fcount = (q.fcount or 0) + 1
        q.ftotal = (q.ftotal or 0) + dur
        if not q.fbest or dur < q.fbest then q.fbest = dur end
    end
    data[run.ep][key] = q
    save()
    -- completed : nil = verification en cours (quete dechargee en jeu), false = non valide.
    -- Aucun autre cas n'est valide : retour a Pioneer 2, lobby, depart de la partie = non.
    local completed = nil
    local why = reason
    if run.finished then
        -- message de fin de quete vu pendant le run : valide, quelle que soit la facon de partir
        completed = true
        why = nil
    elseif run.dead and reason == "quest" then
        completed = false
        why = "died"
    elseif reason ~= "quest" then
        completed = false
    end
    if completed then
        credit_validated(q, dur)
        save()
    end
    local entry = {
        at = run.start, ep = run.ep, diff = run.diff, mode = run.mode, ang = run.ang or 0,
        name = run.name, dur = dur, ok = completed, why = why,
    }
    history[#history + 1] = entry
    while #history > HISTORY_MAX do table.remove(history, 1) end
    save_history()
    last = {
        ep = run.ep, key = key, dur = dur, validated = false,
        completed = completed,
        why = why,
        entry = entry,
        verify_at = os.time() + COMPLETE_CHECK_SECONDS,
    }
end

-- Confirme (ou non) que le dernier run est bien termine.
-- Si on quitte la partie / retourne au lobby juste apres la fin de la quete,
-- c'est un abandon et non un run termine : pas de coche.
local function check_last_completed(in_game)
    if not last or last.completed ~= nil then return end
    if not in_game then
        last.completed = false
        last.why = "left_fast"
        if last.entry then
            last.entry.ok = false
            last.entry.why = "left_fast"
            save_history()
        end
    elseif os.time() >= last.verify_at then
        last.completed = true
        if last.entry then
            last.entry.ok = true
            last.entry.why = nil
            save_history()
        end
        local q = data[last.ep] and data[last.ep][last.key]
        if q then
            credit_validated(q, last.dur)
            save()
        end
    end
end

local function validate_last()
    if not last or last.validated then return end
    local q = data[last.ep] and data[last.ep][last.key]
    if q and (not q.best or last.dur < q.best) then q.best = last.dur end
    last.validated = true
    save()
end

-- Zones de combat/quête (reprises de Kill Counter). Tout ce qui n'est
-- pas dans cette liste (Pioneer 2 EP1/EP2/EP4, transitions...) ne lance
-- PAS le chrono.
local AREA_FLOORS = {}
for _, f in ipairs({
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
    0x0B, 0x0C, 0x0D, 0x0E, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1A, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x23, 0x24,
    0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C,
}) do AREA_FLOORS[f] = true end

-- PV du joueur (offsets de solylib : +0x334 PV, +0x2BC PV max). Renvoie nil si la
-- lecture echoue : la detection de mort est alors simplement ignoree.
local OFFSET_HP, OFFSET_MAXHP = 0x334, 0x2BC
local function get_my_hp()
    local ok, hp, maxhp = pcall(function()
        local idx = pso.read_u32(ADDR_MY_INDEX)
        local player = pso.read_u32(ADDR_PLAYER_ARRAY + 4 * idx)
        if player == 0 then return nil end
        return pso.read_u16(player + OFFSET_HP), pso.read_u16(player + OFFSET_MAXHP)
    end)
    if ok and hp and maxhp and maxhp > 0 and hp <= maxhp then return hp end
    return nil
end

local blocked_id = nil   -- quête terminée au retour P2 : pas de relance
local p2_since = nil     -- depuis quand on est hors zone de combat

local function update()
    if ang_auto then
        local ok_a, e_a = pcall(ang_read)
        if not ok_a then ANGS.err = tostring(e_a) end
        ANGS.tick = (ANGS.tick or 0) + 1
        if ANGS.tick % 180 == 1 then
            local nc = 0
            for _ in pairs(ANGS.cand) do nc = nc + 1 end
            local f = io.open("addons/QuestTracker/ang_status.txt", "w+")
            if f then
                f:write(string.format("tick=%d pos=0x%X wait=%d cand=%d cur=%s hits=%d err=%s\n",
                    ANGS.tick, ANGS.pos, ANGS.wait, nc, tostring(ANGS.cur), #ANGS.hits, tostring(ANGS.err)))
                for ad, v in pairs(ANGS.cand) do f:write(string.format("0x%08X = %s\n", ad, tostring(v))) end
                f:close()
            end
        end
    end
    local qid = get_quest_id()
    local floor = pso.read_u32(ADDR_LOCATION)
    local lobby = pso.read_u32(ADDR_LOCATION + 4) == 0xF
    if lobby then ANGS.cur = nil end -- le message Anguish n'apparait qu'a la creation de la partie
    local pcount = pso.read_u32(ADDR_PLAYER_COUNT)
    -- Le nombre de joueurs peut passer a 0 un instant (attente "All members must be here..." avant un
    -- warp de boss VR) alors que la quete est toujours chargee : on ne coupe pas le run dans ce cas.
    -- Pendant l'attente d'un warp de boss VR (Respective Tomorrow...), le jeu met l'indicateur "lobby"
    -- a vrai alors que la quete est toujours chargee : tant que le meme numero de quete est charge, on
    -- reste en partie. Un vrai retour au lobby decharge la quete (qid = 0).
    local same_quest = (current ~= nil and qid ~= 0 and qid == current.id)
    local in_game = same_quest or ((not lobby) and pcount ~= 0)
    local active = in_game and qid ~= 0
    local in_area = AREA_FLOORS[floor] == true
    local at_p2 = P2_FLOORS[floor] == true
    if current and floor ~= current.dbg_floor then
        current.dbg_floor = floor
        dbg(string.format("etage %d  qid=%s actif=%s p2=%s zone=%s lobby=%s joueurs=%s", floor, tostring(qid),
            tostring(active), tostring(at_p2), tostring(in_area), tostring(lobby), tostring(pcount)))
    end

    if not active then blocked_id = nil end

    -- Suivi pendant le run (seulement tant que la quete est active, pas pendant la sortie de partie).
    if current and active and qid == current.id then

        -- Texte de dialogue lu toutes les ~0,25 s. Le message de fin de quete doit APPARAITRE
        -- pendant le run (absent avant) pour ignorer un vieux message reste en memoire.
        current.frames = (current.frames or 0) + 1
        -- fin de quete : texte lu a chaque image (le message peut s'afficher tres brievement)
        -- fin de quete par registre : doit etre vu a 0 pendant le run, puis passer a > 0
        -- (ignore une valeur deja presente avant le run)
        -- Pause a Pioneer 2 : une fois sorti sur le terrain, le chrono s'arrete tant qu'on est a
        -- Pioneer 2 (floor 0), confirme apres 2 s pour ignorer un 0 passager pendant un warp.
        -- Aussi pour les quetes gouvernementales : leur temps s'arrete a l'arrivee a Pioneer 2 pour la
        -- remise de quete (le dialogue de fin n'est plus compte).
        if not current.finished and not current.wait_start then
            if at_p2 and TM.p2_pause and current.left_p2 then
                current.p2_seen = current.p2_seen or os.time()
                if not current.pause_since and os.time() - current.p2_seen >= 2 then
                    current.pause_since = current.p2_seen
                    dbg("PAUSE (Pioneer 2)")
                end
            else
                current.p2_seen = nil
                if current.pause_since then
                    current.paused = (current.paused or 0) + (os.time() - current.pause_since)
                    current.pause_since = nil
                    dbg("REPRISE etage " .. tostring(floor))
                end
            end
        end
        if current.wait_start then
            local sc = STARTS.map[qid]
            local hit
            -- jamais tant qu'on n'est pas dans une zone de combat (Pioneer 2 EP1/EP2/EP4 n'ont pas le meme etage) : certains registres sont deja a > 0 des le
            -- chargement de la quete (ex. Mop-up) et feraient demarrer le chrono au comptoir
            if sc == "warp" then hit = not at_p2 else hit = ((not at_p2) and REGS.cond_set(sc) == true) end
            if hit then
                current.start = os.time()
                current.wait_start = false
                dbg("DEPART detecte etage " .. tostring(floor))
            end
        end
        if not current.finished then
            local reg_set = REGS.is_set(qid)
            if reg_set == false then
                current.reg_clear = true
            elseif reg_set and current.reg_clear then
                current.finished = true
                current.stop_at = os.time()
            end
        end
        local text = read_dialog_text()
        if is_completion_text(text, in_area) then
            if current.text_clear and not current.finished then
                current.finished = true
                current.stop_at = os.time()
            end
        else
            current.text_clear = true
        end
        -- Simulator 2.0 : le chrono (et son affichage) demarre au message "Stage 1", mais seulement
        -- apres avoir vu "Waiting..." (appui sur la machine) : un vieux "Stage 1" reste en memoire ne
        -- peut donc pas le declencher.
        if not current.sim_started and free_key(current.name) == "simulator20" then
            local low = string.lower(text)
            if string.find(low, "waiting", 1, true) then
                current.sim_waiting = true
            elseif current.sim_waiting and string.find(low, "stage 1", 1, true) then
                current.start = os.time()
                current.sim_started = true
            end
        end
        if current.frames % 15 == 1 then
            -- Quetes gouvernementales : la fin est un dialogue a Pioneer 2 apres l'objectif, puis
            -- le jeu renvoie au lobby. On compte les nouvelles lignes de dialogue vues hors zone.
            if current.gov then
                if in_area then
                    current.p2_last = text
                elseif current.left_p2 and #text > 0 and text ~= current.p2_last then
                    current.p2_last = text
                    current.p2_n = (current.p2_n or 0) + 1
                    current.p2_at = os.time()
                end
            end
        end

        -- Mort : PV a 0 pendant le run. Reste vrai tant qu'on n'est pas reparti au combat
        -- vivant (ex. revive sur place ou retour en zone). Un retour a Pioneer 2 apres une
        -- mort ne compte donc pas comme une quete terminee.
        -- hp_seen evite de croire a une mort si la lecture des PV renvoyait toujours 0.
        local hp = get_my_hp()
        if hp then
            if hp > 0 then current.hp_seen = true end
            if hp == 0 and current.hp_seen then
                current.dead = true
            elseif in_area and hp > 0 then
                current.dead = false
            end
        end
    end

    -- One Person ne peut pas avoir d'autres joueurs : si quelqu'un est
    -- là, le run est forcément en mode Normal.
    if current and current.mode == "solo" and in_game
       and pso.read_u32(ADDR_PLAYER_COUNT) > 1 then
        current.mode = "normal"
    end

    if current then
        if (not active) or qid ~= current.id then
            local reason
            if active then
                reason = "switched"
            elseif in_game then
                reason = "quest"
            else
                reason = "left"
            end
            end_run(reason)
            p2_since = nil
        elseif in_area then
            current.left_p2 = true
            p2_since = nil
        else
            p2_since = nil
        end
    end

    check_last_completed(in_game)

    -- Le chrono démarre des que la quete est prise au comptoir (quete chargee), meme a Pioneer 2
    if not current and active and qid ~= blocked_id then
        current = {
            id = qid, start = os.time(), left_p2 = in_area,
            name = get_quest_name(qid),
            ep = pso.read_u32(ADDR_EPISODE),
            diff = pso.read_u32(ADDR_DIFFICULTY),
            section = pso.read_u32(ADDR_SECTION_ID),
            mode = resolve_mode(),
            ang = (pso.read_u32(ADDR_DIFFICULTY) == 3) and ang_current() or 0, -- Anguish : Ultimate uniquement
        }
        -- quete gouvernementale ("1-1:Planet Ragol", "5-1:Test/VR Temple 1"...)
        current.gov = string.match(current.name or "", "^%d+%-%d+:") ~= nil
        -- le chrono attend le declencheur de debut (registre / interrupteur / arrivee sur le terrain)
        if STARTS.map[qid] ~= nil then
            current.wait_start = true
            current.load_at = current.start
        end
        dbg(string.format("DEBUT run id=%s nom=%s etage=%d wait_start=%s", tostring(qid), tostring(current.name), floor,
            tostring(current.wait_start)))
    end
end


------------------------------------------------------------
-- Catégories (comme dans la Hunter's Guild d'Ephinea)
------------------------------------------------------------
local CATEGORY_ORDER = {
    "Government", "Side Story", "Extermination", "Maximum Attack",
    "Retrieval", "Shop", "VR", "Solo Only", "Event", "Autres",
}

local CATEGORY_QUESTS = {
    ["Government"] = {
        "Planet Ragol", "Torrential Woods", "Subterranean Den", "Infernal Cavern",
        "Deep Within", "The Mutation", "Waterway Shadow", "The Facility",
        "Machines Attack", "Central Control", "The Lost Ruins", "Buried Relics",
        "Hero & Daughter", "The Tomb Stirs", "Dark Inheritance",
        "Test/VR Temple 1", "Test/VR Temple 2", "Test/VR Temple 3", "Test/VR Temple 4",
        "Test/VR Temple 5", "Test/Spaceship 1", "Test/Spaceship 2", "Test/Spaceship 3",
        "Test/Spaceship 4", "Test/Spaceship 5", "From the Past", "Seeking Clues",
        "Silent Beach", "Isle of Mutants", "Below the Waves", "Desire's End",
        "Purple Lamplight", "Missing Research", "Data Retrieval", "Reality & Truth",
        "Pursuit", "The Chosen (1/2)", "The Chosen (2/2)", "Sacred Ground",
        "The Final Cycle",
    },
    ["Side Story"] = {
        "Battle Training", "Magnitude of Metal", "Claiming a Stake", "The Value of Money",
        "Journalistic Pursuit", "The Fake in Yellow", "Native Research", "Forest of Sorrow",
        "Gran Squall", "Addicting Food", "The Lost Bride", "Waterfall Tears",
        "Black Paper", "Secret Delivery", "Soul of a Blacksmith", "Letter from Lionel",
        "The Grave's Butler", "Knowing One's Heart", "The Retired Hunter",
        "Dr. Osto's Research", "Unsealed Door", "Soul of Steel", "Doc's Secret Plan",
        "Seek my Master", "From the Depths", "Central Dome Fire Swirl",
        "Seat of the Heart", "Blue Star Memories", "Warrior's Pride",
        "The Restless Lion", "Pioneer Spirit", "Black Paper's Dangerous Deal",
        "Black Paper's Dangerous Deal 2",
    },
    ["Extermination"] = {
        "Today's Rate", "Gal Da Val's Darkness", "CAL's Clock Challenge",
        "Point of Disaster", "The Robots' Reckoning",
    },
    ["Maximum Attack"] = {
        "Random Attack Xrd Stage", "Random Attack Xrd REV 1", "Random Attack Xrd REV 2",
        "Random Attack Xrd REV 4", "Maximum Attack E: Episode 1", "Maximum Attack E: VR",
        "Maximum Attack E: Gal Da Val", "Maximum Attack E: Episode 4",
    },
    ["Retrieval"] = {
        "The Missing Maracas", "Fragments of a Memory", "Rappy's Holiday",
        "Gallon's Treachery", "Rescue from Ragol", "Forsaken Friends",
        "This Must Be The Place", "Road To Nowhere", "Dream Messenger",
        "Revisiting Darkness", "Dolmolm Research",
    },
    ["Shop"] = {
        "Christmas Event Shop", "Anniversary Badge Shop", "The Forge", "Gallon's Shop",
        "Item Present", "Singing by the Beach", "Beach Laughter",
        "To The Deepest Blue -MA4 Venue-", "TA Reward Shop", "The Egg Shop",
        "Seasons Shop", "My Career", "Claire's Deal 5", "The Beak's Cafe Ver.2",
    },
    ["VR"] = {
        "Towards the Future", "Tyrell's Ego", "Labyrinthine Trial", "Sugoroku",
        "Simulator 2.0", "Mine Offensive", "Endless: Episode 1", "Reach for the Dream",
        "Respective Tomorrow", "Endless: Episode 2",
    },
    ["Solo Only"] = {
        "Gallon's Plan", "Good Luck!", "AOL CUP -Sunset Base-", "Knight of Coral",
        "Knight of Coral Advent", "A New Hope",
    },
    ["Event"] = {
        "Christmas Fiasco", "Solstice Snafu", "December Disaster #1", "December Disaster #2",
        "August Atrocity 1", "August Atrocity 2", "Festivity on the Beach",
        "Pioneer Christmas", "Pioneer Halloween", "Rappy Halloween",
    },
}

-- Familles de quêtes numérotées (préfixe normalisé -> catégorie)
local CATEGORY_PREFIXES = {
    { "mopupoperation", "Extermination" }, { "sweepupoperation", "Extermination" },
    { "endlessnightmare", "Extermination" }, { "anomalousordeal", "Extermination" },
    { "scarletrealm", "Extermination" }, { "silentafterimage", "Extermination" },
    { "phantasmalworld", "Extermination" }, { "penumbralsurge", "Extermination" },
    { "waroflimits", "Extermination" }, { "newmopupoperation", "Extermination" },
    { "lost", "Retrieval" }, { "hollow", "Event" },
    { "maximumattacke", "Event" },
}

local function norm_name(n)
    n = n:lower():gsub("^%d+%-%d+%s*:?%s*", "")
    return (n:gsub("[^%w]", ""))
end

local CATEGORY_LOOKUP = {}
for cat, names in pairs(CATEGORY_QUESTS) do
    for _, n in ipairs(names) do CATEGORY_LOOKUP[norm_name(n)] = cat end
end

local function get_category(name)
    local n = norm_name(name or "")
    if CATEGORY_LOOKUP[n] then return CATEGORY_LOOKUP[n] end
    -- Maximum Attack 1 Ver2, 4th Stage -1A-, etc.
    if n:find("^maximumattack%d") then return "Maximum Attack" end
    for _, rule in ipairs(CATEGORY_PREFIXES) do
        if n:sub(1, #rule[1]) == rule[1] then return rule[2] end
    end
    return "Autres"
end

------------------------------------------------------------
-- Interface
------------------------------------------------------------
local function fmt(t)
    if not t then return "--:--" end
    return string.format("%d:%02d", math.floor(t / 60), t % 60)
end

local function mode_button()
    local label
    if mode_pref == "auto" then
        label = T("Auto") .. " (" .. T(MODE_NAMES[resolve_mode()]) .. ")"
    else
        label = T(MODE_NAMES[mode_pref])
    end
    if imgui.Button(T("Mode :") .. " " .. label) then
        if mode_pref == "auto" then mode_pref = "solo"
        elseif mode_pref == "solo" then mode_pref = "normal"
        else mode_pref = "auto" end
        if current then current.mode = resolve_mode() end
        save_settings()
    end
end

-- Niveau d'Anguish de la partie en cours (le jeu ne l'expose pas : a regler a la main avant le run)
local function ang_button()
    local items = { T("Auto"), T("Off") }
    for i = 1, ANG_MAX do items[#items + 1] = (LANG == "ja" and "アングィッシュ" or "Ang") .. i end
    local cur = ang_auto and 1 or (ang_level + 2)
    imgui.Text(T("Anguish :"))
    imgui.SameLine(0, 8)
    imgui.PushItemWidth(LANG == "ja" and 150 or 90)
    local ok_c, changed, idx = pcall(imgui.Combo, "##ang_level", cur, items, #items)
    imgui.PopItemWidth()
    if ok_c then
        if changed then
            if idx == 1 then
                ang_auto = true
            else
                ang_auto = false
                ang_level = idx - 2
            end
            save_settings()
        end
    else
        -- secours si le menu deroulant n'existe pas : un bouton qui fait defiler les choix
        if imgui.Button(items[cur] .. "##ang_btn") then
            cur = (cur % #items) + 1
            ang_auto = (cur == 1)
            if not ang_auto then ang_level = cur - 2 end
            save_settings()
        end
    end
    if ang_auto then
        imgui.SameLine(0, 8)
        local n = ang_read()
        imgui.TextDisabled(n and (T("lu : Ang") .. n) or T("lu : aucun"))
    end
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(T("Auto : lit le niveau dans le bloc Anguish affiche par le jeu. Sinon reglage manuel."))
        imgui.EndTooltip()
    end
end

-- Pendant une quete : fenetre totalement transparente, seul le timer reste visible.
local TRANSPARENT_COLORS = {
    "WindowBg", "Border", "BorderShadow",
    "ResizeGrip", "ResizeGripHovered", "ResizeGripActive",
}

-- Texte "en gras" : imgui n'a pas de police grasse, on dessine le texte deux fois
-- avec 1 pixel d'ecart. Si la position du curseur est illisible, un seul trace.
local TIMER_SCALE = 1.5  -- taille du timer en quete (1.0 = normale)

local function draw_bold(text)
    if TIMER_SCALE ~= 1 then pcall(imgui.SetWindowFontScale, TIMER_SCALE) end
    local ok, x = pcall(imgui.GetCursorPosX)
    imgui.Text(text)
    if ok and type(x) == "number" then
        imgui.SameLine(x + 1)
        imgui.Text(text)
    end
    if TIMER_SCALE ~= 1 then pcall(imgui.SetWindowFontScale, 1) end
end

local function clip(s, n)
    s = tostring(s or "")
    if #s > n then return s:sub(1, n - 1) .. "~" end
    return s
end

local function fmt_date(ts)
    local ok, s = pcall(os.date, "%d/%m %H:%M", ts)
    return ok and s or "?"
end

-- Barre de recherche (partagee par "Time Attack / Personal Best" et "Liste de quete").
-- Renvoie le texte cherche en minuscules ("" si la zone est vide).
local quest_search = ""
local function draw_search_box(id)
    imgui.Text(T("Recherche :"))
    imgui.SameLine(0, 8)
    imgui.PushItemWidth(200)
    local _
    _, quest_search = imgui.InputText("##search_" .. id, quest_search, 64)
    imgui.PopItemWidth()
    imgui.SameLine(0, 6)
    if imgui.Button("X##search_clear_" .. id) then quest_search = "" end
end

-- Liste des quetes (source : wiki Ephinea, page Quests). Les noms non-ASCII sont omis ;
-- une quete absente de cette liste apparait dans la categorie "Autres" de son episode.
local QUEST_LIST = {
    [0] = {
        { cat = "Government", names = {
            "1-1:Planet Ragol", "1-2:Torrential Woods", "1-3:Subterranean Den",
            "2-1:Infernal Cavern", "2-2:Deep Within", "2-3:The Mutation",
            "2-4:Waterway Shadow", "3-1:The Facility", "3-2:Machines Attack",
            "3-3:Central Control", "4-1:The Lost Ruins", "4-2:Buried Relics",
            "4-3:Hero & Daughter", "4-4:The Tomb Stirs", "4-5:Dark Inheritance",
        } },
        { cat = "Extermination", names = {
            "Mop-up Operation #1", "Mop-up Operation #2", "Mop-up Operation #3",
            "Mop-up Operation #4", "Sweep-up Operation #1", "Sweep-up Operation #2",
            "Sweep-up Operation #3", "Sweep-up Operation #4", "Endless Nightmare #1",
            "Endless Nightmare #2", "Endless Nightmare #3", "Endless Nightmare #4",
            "Today's Rate", "Anomalous Ordeal #1", "Anomalous Ordeal #2",
            "Scarlet Realm #1", "Scarlet Realm #2", "Scarlet Realm #3",
            "Scarlet Realm #4", "Silent Afterimage #1", "Silent Afterimage #2",
            "Chronocide Trial #1", "Chronocide Trial #2", "Chronocide Trial #3",
            "Chronocide Trial #4", "Ruins Wreckage",
        } },
        { cat = "Maximum Attack", names = {
            "MAXIMUM ATTACK 1 Ver2", "Maximum Attack 4th Stage -1A-", "Maximum Attack 4th Stage -1B-",
            "Maximum Attack 4th Stage -1C-", "Maximum Attack 4th Stage -1R-", "Random Attack Xrd Stage",
            "Maximum Attack E: Episode 1", "Random Attack Xrd REV 1",
        } },
        { cat = "Retrieval", names = {
            "The Missing Maracas", "Lost HEAT SWORD", "Lost ICE SPINNER",
            "Lost SOUL BLADE", "Lost HELL PALLASCH", "Fragments of a Memory",
            "Rappy's Holiday", "Gallon's Treachery", "Rescue from Ragol",
            "Forsaken Friends", "This Must Be The Place", "Road To Nowhere",
            "Lost Son Jim", "Subterranean Patrol #1", "Subterranean Patrol #2",
            "Subterranean Patrol #3", "Underworld Patrol #1",
        } },
        { cat = "Shop", names = {
            "Christmas Event Shop", "Anniversary Badge Shop", "The Forge",
        } },
        { cat = "VR", names = {
            "Towards the Future", "Tyrell's Ego", "Labyrinthine Trial",
            "Sugoroku", "Simulator 2.0", "Mine Offensive",
            "Endless: Episode 1", "Virtual Limits 1", "Virtual Limits 2",
            "Virtual Vortex 1", "Virtual Vortex 2",
        } },
        { cat = "Halloween", names = {
            "Hollow Battlefield: Forest", "Hollow Battlefield: Cave", "Hollow Battlefield: Mine",
            "Hollow Battlefield: Ruins",
        } },
        { cat = "Side Story", names = {
            "Battle Training", "Magnitude of Metal", "Claiming a Stake",
            "The Value of Money", "Journalistic Pursuit", "The Fake in Yellow",
            "Native Research", "Forest of Sorrow", "Gran Squall",
            "Addicting Food", "The Lost Bride", "Waterfall Tears",
            "Black Paper", "Secret Delivery", "Soul of a Blacksmith",
            "Letter from Lionel", "The Grave's Butler", "Knowing One's Heart",
            "The Retired Hunter", "Dr. Osto's Research", "Unsealed Door",
            "Soul of Steel", "Doc's Secret Plan", "Seek my Master",
            "From the Depths", "Central Dome Fire Swirl",
        } },
        { cat = "Solo Only", names = {
            "Gallon's Plan", "Good Luck!", "AOL CUP -Sunset Base-",
            "Knight of Coral",
        } },
        { cat = "Event", names = {
            "Christmas Fiasco", "Solstice Snafu", "December Disaster #1",
            "August Atrocity 1",
        } },
        { cat = "Sandbox Only", names = {
            "Maximum Attack E: Forest", "Maximum Attack E: Cave", "Maximum Attack E: Mine",
            "Maximum Attack E: Ruins",
        } },
    },
    [1] = {
        { cat = "Government", names = {
            "5-1:Test/VR Temple 1", "5-2:Test/VR Temple 2", "5-3:Test/VR Temple 3",
            "5-4:Test/VR Temple 4", "5-5:Test/VR Temple 5", "6-1:Test/Spaceship 1",
            "6-2:Test/Spaceship 2", "6-3:Test/Spaceship 3", "6-4:Test/Spaceship 4",
            "6-5:Test/Spaceship 5", "7-1:From the Past", "7-2:Seeking Clues",
            "7-3:Silent Beach", "7-4:Central Control", "7-5:Isle of Mutants",
            "8-1:Below the Waves", "8-2:Desire's End", "8-3:Purple Lamplight",
        } },
        { cat = "Extermination", names = {
            "Phantasmal World #1", "Phantasmal World #2", "Phantasmal World #3",
            "Phantasmal World #4", "Sweep-up Operation #5", "Sweep-up Operation #6",
            "Sweep-up Operation #7", "Sweep-up Operation #8", "Sweep-up Operation #9",
            "Penumbral Surge #1", "Penumbral Surge #2", "Penumbral Surge #3",
            "Penumbral Surge #4", "Penumbral Surge #5", "Penumbral Surge #6",
            "Anomalous Ordeal #3", "Anomalous Ordeal #4", "Anomalous Ordeal #5",
            "Gal Da Val's Darkness", "CAL's Clock Challenge",
        } },
        { cat = "Maximum Attack", names = {
            "MAXIMUM ATTACK 2 Ver2", "Maximum Attack 4th Stage -2A-", "Maximum Attack 4th Stage -2B-",
            "Maximum Attack 4th Stage -2C-", "Maximum Attack 4th Stage -2R-", "Random Attack Xrd Stage",
            "Maximum Attack E: VR", "Maximum Attack E: Gal Da Val", "Random Attack Xrd REV 2",
        } },
        { cat = "Retrieval", names = {
            "Lost SHOCK RIFLE", "Lost BIND ASSAULT", "Lost FILL CANNON",
            "Lost DEMON'S RAILGUN", "Lost CHARGE VULCAN", "Dream Messenger",
            "Revisiting Darkness", "Dolmolm Research",
        } },
        { cat = "Shop", names = {
            "Gallon's Shop", "Item Present", "Singing by the Beach",
            "Beach Laughter", "To The Deepest Blue -MA4 Venue-", "TA Reward Shop",
            "The Egg Shop", "Seasons Shop", "My Career",
        } },
        { cat = "Tower", names = {
            "The East Tower", "The West Tower", "Raid on Central Tower",
            "The Military Strikes Back", "Twilight Sanctuary",
        } },
        { cat = "VR", names = {
            "Reach for the Dream", "Respective Tomorrow", "Endless: Episode 2",
        } },
        { cat = "Halloween", names = {
            "Hollow Reality: Temple", "Hollow Reality: Spaceship", "Hollow Phantasm: Jungle",
            "Hollow Phantasm: Seabed", "Hollow Phantasm: Tower",
        } },
        { cat = "Side Story", names = {
            "Seat of the Heart", "Blue Star Memories",
        } },
        { cat = "Solo Only", names = {
            "Knight of Coral Advent", "A New Hope",
        } },
        { cat = "Event", names = {
            "Festivity on the Beach", "Christmas Fiasco", "December Disaster #2",
            "Pioneer Christmas", "Pioneer Halloween", "Rappy Halloween",
            "August Atrocity 2",
        } },
        { cat = "Sandbox Only", names = {
            "Maximum Attack E: Temple", "Maximum Attack E: Spaceship", "Maximum Attack E: CCA",
            "Maximum Attack E: Seabed", "Maximum Attack E: Tower", "The Gloom Spire",
        } },
    },
    [2] = {
        { cat = "Government", names = {
            "9-1:Missing Research", "9-2:Data Retrieval", "9-3:Reality & Truth",
            "9-4:Pursuit", "9-5:The Chosen (1/2)", "9-6:The Chosen (2/2)",
            "9-7:Sacred Ground", "9-8:The Final Cycle",
        } },
        { cat = "Extermination", names = {
            "Point of Disaster", "The Robots' Reckoning", "War of Limits #1",
            "War of Limits #2", "War of Limits #3", "War of Limits #4",
            "War of Limits #5", "New Mop-Up Operation #1", "New Mop-Up Operation #2",
            "New Mop-Up Operation #3", "New Mop-Up Operation #4", "New Mop-Up Operation #5",
            "Sweep-up Operation #10", "Sweep-up Operation #11", "Sweep-up Operation #12",
            "Sweep-up Operation #13", "Sweep-up Operation #14",
        } },
        { cat = "Retrieval", names = {
            "Lost BERSERK BATON", "Lost SPIRIT STRIKER",
        } },
        { cat = "Maximum Attack", names = {
            "MAXIMUM ATTACK 3 Ver2", "Maximum Attack 4th Stage -4A-", "Maximum Attack 4th Stage -4B-",
            "Maximum Attack 4th Stage -4C-", "Maximum Attack 4th Stage -4R-", "Maximum Attack E: Episode 4",
            "Random Attack Xrd REV 4",
        } },
        { cat = "Shop", names = {
            "Claire's Deal 5", "The Beak's Cafe Ver.2",
        } },
        { cat = "VR", names = {
            "Beyond the Horizon",
        } },
        { cat = "Halloween", names = {
            "Hollow Wasteland: Wilderness", "Hollow Wasteland: Desert",
        } },
        { cat = "Side Story", names = {
            "Warrior's Pride", "The Restless Lion", "Pioneer Spirit",
            "Black Paper's Dangerous Deal", "Black Paper's Dangerous Deal 2",
        } },
        { cat = "Event", names = {
            "Christmas Fiasco",
        } },
        { cat = "Sandbox Only", names = {
            "Maximum Attack E: Crater", "Maximum Attack E: Desert",
        } },
    },
}

local LIST_EP_LABELS = { [0] = "Episode 1", [1] = "Episode 2", [2] = "Episode 4" }

-- Nom normalise pour comparer les noms du jeu et ceux du wiki (sans majuscules ni symboles)
local function norm_name(s)
    return (tostring(s or ""):lower():gsub("[^%w]", ""))
end

-- Monstres par quete (fichier quest_monsters.lua, tire du Quests.lua de Drop Chart).
-- Cliquer sur le nom d'une quete ouvre une fenetre avec ses monstres, zone par zone.
local MOBS = { loaded = false, idx = {}, sel = nil, open = false }

local function mobs_load()
    if MOBS.loaded then return end
    MOBS.loaded = true
    local chunk = loadfile("addons/QuestTracker/quest_monsters.lua")
    if not chunk then return end
    local ok, res = pcall(chunk)
    if not ok or type(res) ~= "table" then return end
    for name, areas in pairs(res) do
        local entry = { name = name, areas = areas }
        MOBS.idx[norm_name(name)] = entry
        -- version sans le prefixe "1-1:" pour retrouver les noms du jeu
        local short = name:gsub("^%d+%-%d+:%s*", "")
        if MOBS.idx[norm_name(short)] == nil then MOBS.idx[norm_name(short)] = entry end
    end
end

-- Nom de quete cliquable : ouvre la fenetre des monstres
local function quest_button(name, uid)
    if imgui.Button(QN(name) .. "##qm_" .. uid .. "_" .. name) then
        MOBS.sel = name
        MOBS.open = true
    end
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(T("Cliquer pour voir les monstres"))
        imgui.EndTooltip()
    end
end

-- Grille de quetes : 3 colonnes (bouton + nombre de runs), pour que les longues categories
-- tiennent a l'ecran. items = { {name=..., count=...}, ... }
local GRID_X = { 0, 330, 640 }
local function quest_grid(items, uid)
    local cols = #GRID_X
    local rows = math.ceil(#items / cols)
    -- ordre vertical : on descend la 1ere colonne, puis la 2e, puis la 3e
    for r = 1, rows do
        for c = 1, cols do
            local it = items[(c - 1) * rows + r]
            if it then
                if c > 1 then imgui.SameLine(GRID_X[c]) end
                quest_button(it.name, uid)
                imgui.SameLine(0, 6)
                if it.count > 0 then
                    imgui.TextColored(0.5, 1, 0.5, 1, "x" .. it.count)
                else
                    imgui.TextColored(0.5, 0.5, 0.5, 1, "x0")
                end
            end
        end
    end
end

-- Abreviations des quetes (fichier quest_abbr.lua) : taper l'abreviation exacte dans la recherche
local ABBR = { loaded = false, idx = {} }

local function abbr_load()
    if ABBR.loaded then return end
    ABBR.loaded = true
    local chunk = loadfile("addons/QuestTracker/quest_abbr.lua")
    if not chunk then return end
    local ok, res = pcall(chunk)
    if not ok or type(res) ~= "table" then return end
    for name, ab in pairs(res) do
        ABBR.idx[norm_name(name)] = ab
        local short = name:gsub("^%d+%-%d+:%s*", "")
        if ABBR.idx[norm_name(short)] == nil then ABBR.idx[norm_name(short)] = ab end
    end
end

local function quest_abbr(name)
    abbr_load()
    return ABBR.idx[norm_name(name)]
end

-- La recherche (deja en minuscules) trouve le nom contenant le texte, ou une abreviation qui commence par ce texte
local function quest_matches(name, query)
    if query == "" then return true end
    if string.find(string.lower(name or ""), query, 1, true) then return true end
    local ab = quest_abbr(name or "")
    if ab == nil then return false end
    ab = string.lower(ab)
    -- "muo" trouve muo1, muo2... : l'abreviation peut commencer par le texte tape (2 lettres minimum)
    return ab == query or (#query >= 2 and string.sub(ab, 1, #query) == query)
end

local function draw_mobs_window()
    if not MOBS.open or not MOBS.sel then return end
    mobs_load()
    local success
    success, MOBS.open = imgui.Begin(T("Monstres de la quete") .. "###qcmobs", MOBS.open, {})
    if success then
        imgui.TextColored(1, 0.8, 0.4, 1, QN(MOBS.sel))
        local ab = quest_abbr(MOBS.sel)
        if ab then
            imgui.SameLine(0, 16)
            imgui.TextDisabled(T("abreviation : ") .. ab)
        end
        do
            local fk = free_key(MOBS.sel)
            if imgui.Checkbox(T("Suivi libre : PB et moyenne meme sans finir la quete") .. "##free_run", FREE[fk] == true) then
                FREE[fk] = (FREE[fk] ~= true) or nil
                save_settings()
            end
        end
        imgui.Separator()
        local entry = MOBS.idx[norm_name(MOBS.sel)]
        if not entry then
            imgui.TextDisabled(T("Aucune donnee de monstres pour cette quete."))
            if not MOBS.loaded or next(MOBS.idx) == nil then
                imgui.TextDisabled(T("(fichier quest_monsters.lua introuvable ?)"))
            end
        else
            -- zones cote a cote (par blocs de 4 colonnes max), un monstre par ligne
            local COL_W, PER_BLOCK = 240, 4
            local function draw_columns(cols)
                for first = 1, #cols, PER_BLOCK do
                    local last_i = math.min(first + PER_BLOCK - 1, #cols)
                    imgui.Spacing()
                    local rows = 0
                    for i = first, last_i do
                        if i > first then imgui.SameLine((i - first) * COL_W) end
                        imgui.TextColored(0.4, 0.8, 1, 1, cols[i][1])
                        rows = math.max(rows, #cols[i][2])
                    end
                    for r = 1, rows do
                        for i = first, last_i do
                            local x = (i - first) * COL_W
                            if i > first then imgui.SameLine(x) end
                            local m = cols[i][2][r]
                            if m then
                                imgui.Text(m[1])
                                imgui.SameLine(x + 165)
                                imgui.TextColored(0.7, 0.7, 0.7, 1, "x" .. m[2])
                            else
                                imgui.Text(T(" "))
                            end
                        end
                    end
                end
            end

            -- zones (sans le "Total" du fichier, recalcule ci-dessous)
            local zones = {}
            for _, a in ipairs(entry.areas) do
                if a[1] ~= "Total" then zones[#zones + 1] = a end
            end
            draw_columns(zones)

            -- total : monstres regroupes par nom, repartis en 4 colonnes
            if #zones > 1 then
                local order, sums, unknown = {}, {}, {}
                for _, a in ipairs(zones) do
                    for _, m in ipairs(a[2]) do
                        local n = tonumber(string.match(m[2], "^%s*(%d+)"))
                        if sums[m[1]] == nil then
                            order[#order + 1] = m[1]
                            sums[m[1]] = 0
                        end
                        if n then sums[m[1]] = sums[m[1]] + n else unknown[m[1]] = true end
                    end
                end
                local per_col = math.ceil(#order / PER_BLOCK)
                local cols = {}
                for c = 1, PER_BLOCK do
                    local list = {}
                    for r = 1, per_col do
                        local name = order[(c - 1) * per_col + r]
                        if name then
                            local txt = tostring(sums[name])
                            if unknown[name] then txt = (sums[name] > 0) and (txt .. "+?") or "?" end
                            list[#list + 1] = { name, txt }
                        end
                    end
                    cols[#cols + 1] = { c == 1 and "Total" or " ", list }
                end
                imgui.Spacing()
                imgui.Separator()
                draw_columns(cols)
            end
        end
    end
    imgui.End()
end

-- Nombre de lancements par quete et par episode (tous modes et difficultes confondus)
local function count_by_name(ep)
    local counts, names = {}, {}
    for _, q in pairs(data[ep] or {}) do
        local k = norm_name(q.name)
        counts[k] = (counts[k] or 0) + q.count
        names[k] = names[k] or q.name
    end
    return counts, names
end

-- Onglet "Liste de quete" : 3 sous-onglets (Ep1, Ep2, Ep4), nom de la quete + nombre de fois
local QRESET = { step = 0 } -- reset des quetes : 0 = repos, 1 = 1ere confirmation, 2 = derniere confirmation

local function draw_quest_reset()
    if QRESET.step == 0 then
        if imgui.Button(Tb("Reset des quetes")) then QRESET.step = 1 end
    elseif QRESET.step == 1 then
        imgui.TextColored(1, 0.7, 0.3, 1, T("Remettre toutes les quetes a 0 ?"))
        imgui.SameLine(0, 10)
        if imgui.Button(T("Oui") .. "##qreset1") then QRESET.step = 2 end
        imgui.SameLine(0, 6)
        if imgui.Button(T("Non") .. "##qreset1n") then QRESET.step = 0 end
    else
        imgui.TextColored(1, 0.35, 0.35, 1, T("Derniere confirmation : compteurs, temps et PB seront effaces. Sur ?"))
        imgui.SameLine(0, 10)
        if imgui.Button(T("Oui, tout effacer") .. "##qreset2") then
            data = {}
            last = nil
            QRESET.step = 0
            save()
        end
        imgui.SameLine(0, 6)
        if imgui.Button(T("Non") .. "##qreset2n") then QRESET.step = 0 end
    end
end

local function draw_quest_list()
    for ep = 0, 2 do
        if ep > 0 then imgui.SameLine(0, 10) end
        local label = T(LIST_EP_LABELS[ep])
        if imgui.Button((list_ep == ep and ("[" .. label .. "]") or label) .. "##listep" .. ep) then
            list_ep = ep
        end
    end
    imgui.SameLine(0, 24)
    draw_search_box("list")
    imgui.SameLine(0, 24)
    draw_quest_reset()
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()

    local query = string.lower(quest_search or "")
    -- Recherche active : on cherche dans les 3 episodes, resultats a plat avec l'episode et la categorie
    if query ~= "" then
        local found = 0
        for ep = 0, 2 do
            local counts, names = count_by_name(ep)
            local seen = {}
            for _, group in ipairs(QUEST_LIST[ep] or {}) do
                for _, n in ipairs(group.names) do
                    seen[norm_name(n)] = true
                    if quest_matches(n, query) then
                        found = found + 1
                        local c = counts[norm_name(n)] or 0
                        quest_button(n, "sf" .. ep)
                        imgui.SameLine(0, 18)
                        if c > 0 then
                            imgui.TextColored(0.5, 1, 0.5, 1, "x" .. c)
                        else
                            imgui.TextColored(0.5, 0.5, 0.5, 1, "x0")
                        end
                        imgui.SameLine(0, 18)
                        imgui.TextColored(0.6, 0.6, 0.6, 1, T(LIST_EP_LABELS[ep]) .. " - " .. T(group.cat))
                        imgui.Spacing()
                    end
                end
            end
            for k, c in pairs(counts) do
                if not seen[k] and quest_matches(names[k], query) then
                    found = found + 1
                    quest_button(names[k], "sa" .. ep)
                    imgui.SameLine(0, 18)
                    imgui.TextColored(0.5, 1, 0.5, 1, "x" .. c)
                    imgui.SameLine(0, 18)
                    imgui.TextColored(0.6, 0.6, 0.6, 1, T(LIST_EP_LABELS[ep]) .. " - " .. T("Autres"))
                    imgui.Spacing()
                end
            end
        end
        if found == 0 then imgui.TextDisabled(T("(aucune quete trouvee)")) end
        return
    end

    local counts, names = count_by_name(list_ep)
    local seen = {}

    for _, group in ipairs(QUEST_LIST[list_ep] or {}) do
        local done = 0
        for _, n in ipairs(group.names) do
            local k = norm_name(n)
            seen[k] = true
            if (counts[k] or 0) > 0 then done = done + 1 end
        end
        local title = string.format("%s (%d/%d)##ql_%d_%s", T(group.cat), done, #group.names, list_ep, group.cat)
        if imgui.TreeNodeEx(title) then
            local items = {}
            for _, n in ipairs(group.names) do
                items[#items + 1] = { name = n, count = counts[norm_name(n)] or 0 }
            end
            quest_grid(items, "t")
            imgui.TreePop()
        end
    end

    -- quetes jouees mais absentes de la liste du wiki
    local others = {}
    for k, c in pairs(counts) do
        if not seen[k] then others[#others + 1] = { name = names[k], count = c } end
    end
    if #others > 0 then
        table.sort(others, function(x, y) return x.name < y.name end)
        if imgui.TreeNodeEx(string.format(T("Autres") .. " (%d)##ql_%d_autres", #others, list_ep)) then
            quest_grid(others, "o")
            imgui.TreePop()
        end
    end
end

-- Onglet Historique : un run par ligne, le plus recent en haut
-- (date, quete, temps, valide ou non)
local function draw_history()
    local total, valid = #history, 0
    for _, h in ipairs(history) do
        if h.ok then valid = valid + 1 end
    end
    imgui.Text(string.format(T("%d runs | %d valides"), total, valid))
    imgui.SameLine(0, 16)
    if confirm_clear_history then
        imgui.Text(T(confirm_clear_history == "invalid" and "Vider les non valides ?" or "Vider l'historique ?"))
        imgui.SameLine(0, 8)
        if imgui.Button(T("Oui") .. "##hist_clear") then
            if confirm_clear_history == "invalid" then
                local kept = {}
                for _, h in ipairs(history) do
                    if h.ok then kept[#kept + 1] = h end
                end
                history = kept
            else
                history = {}
            end
            confirm_clear_history = false
            save_history()
            total = #history
        end
        imgui.SameLine(0, 6)
        if imgui.Button(Tb("Non##hist_clear")) then confirm_clear_history = false end
    else
        if imgui.Button(Tb("Vider l'historique")) then confirm_clear_history = true end
        imgui.SameLine(0, 8)
        if imgui.Button(Tb("Vider les non valides")) then confirm_clear_history = "invalid" end
    end
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()

    imgui.TextDisabled(T("Date"))
    imgui.SameLine(110)
    imgui.TextDisabled(T("Quete"))
    imgui.SameLine(330)
    imgui.TextDisabled(T("Mode"))
    imgui.SameLine(430)
    imgui.TextDisabled(T("Difficulte"))
    imgui.SameLine(520)
    imgui.TextDisabled(T("Anguish"))
    imgui.SameLine(600)
    imgui.TextDisabled(T("Temps"))
    imgui.SameLine(670)
    imgui.TextDisabled(T("Valide"))
    imgui.Separator()

    if total == 0 then
        imgui.TextDisabled(T("(aucun run enregistre)"))
        return
    end

    for i = total, 1, -1 do
        local h = history[i]
        imgui.TextColored(0.7, 0.7, 0.7, 1, fmt_date(h.at))
        imgui.SameLine(110)
        imgui.Text(QN(h.name) == h.name and clip(h.name, 28) or QN(h.name))
        imgui.SameLine(330)
        imgui.Text(T(MODE_NAMES[h.mode] or "?"))
        imgui.SameLine(430)
        imgui.TextColored(1, 0.8, 0.4, 1, DIFF_NAMES[h.diff] or "?")
        imgui.SameLine(520)
        if (h.ang or 0) > 0 then
            imgui.TextColored(1, 0.5, 0.5, 1, "Ang" .. h.ang)
        else
            imgui.TextDisabled(T("-"))
        end
        imgui.SameLine(600)
        imgui.Text(fmt(h.dur))
        imgui.SameLine(670)
        if h.ok then
            imgui.TextColored(0.4, 1, 0.5, 1, T("Valide"))
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text(T("Run valide (quete terminee)"))
                imgui.EndTooltip()
            end
        else
            imgui.TextColored(1, 0.4, 0.4, 1, T("Non"))
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text(T("Run non valide : ") .. T(WHY_TEXT[h.why] or "?"))
                imgui.EndTooltip()
            end
        end
        imgui.Spacing()
    end
end

-- Theme : bleu nuit avec accent indigo (couleurs seulement, les couleurs sont retirees apres)
local THEME = {
    { "WindowBg", 0.06, 0.07, 0.11, 0.95 },
    { "PopupBg", 0.08, 0.09, 0.15, 0.98 },
    { "TitleBg", 0.10, 0.12, 0.24, 1 },
    { "TitleBgActive", 0.22, 0.25, 0.52, 1 },
    { "TitleBgCollapsed", 0.10, 0.12, 0.24, 0.9 },
    { "Button", 0.16, 0.19, 0.34, 1 },
    { "ButtonHovered", 0.28, 0.33, 0.62, 1 },
    { "ButtonActive", 0.38, 0.44, 0.80, 1 },
    { "FrameBg", 0.11, 0.13, 0.22, 1 },
    { "FrameBgHovered", 0.18, 0.21, 0.38, 1 },
    { "FrameBgActive", 0.24, 0.28, 0.50, 1 },
    { "Header", 0.18, 0.21, 0.40, 1 },
    { "HeaderHovered", 0.28, 0.33, 0.62, 1 },
    { "HeaderActive", 0.35, 0.41, 0.74, 1 },
    { "Border", 0.25, 0.29, 0.50, 0.55 },
    { "Separator", 0.30, 0.35, 0.60, 0.65 },
    { "CheckMark", 0.45, 0.92, 0.68, 1 },
    { "Text", 0.92, 0.94, 1.00, 1 },
    { "TextDisabled", 0.52, 0.56, 0.72, 1 },
    { "ScrollbarBg", 0.06, 0.07, 0.11, 0.6 },
    { "ScrollbarGrab", 0.28, 0.33, 0.58, 1 },
}
local ACCENT = { 0.55, 0.65, 1.0, 1 }      -- titres et onglet actif
local TAB_ON = { 0.30, 0.36, 0.78, 1 }

local function push_theme()
    local n = 0
    for _, c in ipairs(THEME) do
        if pcall(imgui.PushStyleColor, c[1], c[2], c[3], c[4], c[5]) then n = n + 1 end
    end
    return n
end

local function pop_theme(n)
    for _ = 1, n do pcall(imgui.PopStyleColor) end
end

-- Bouton d'onglet : l'onglet actif est colore (plus de crochets)
local function tab_button(label, key)
    local active = (current_tab == key)
    local n = 0
    if active then
        for _, name in ipairs({ "Button", "ButtonHovered", "ButtonActive" }) do
            if pcall(imgui.PushStyleColor, name, TAB_ON[1], TAB_ON[2], TAB_ON[3], TAB_ON[4]) then n = n + 1 end
        end
    end
    if imgui.Button(label) then current_tab = key end
    pop_theme(n)
end

-- Fenetre du timer : separee de la fenetre Quest Tracker, totalement transparente,
-- affichee uniquement pendant un run (meme si Quest Tracker est fermee).
-- Tu peux la deplacer en la faisant glisser par le timer.
-- Contenu du timer (utilise par la fenetre en quete et par l'apercu de l'onglet Timer)
local function timer_body(name, dur, pb, paused)
    if TM.name then
        local n = tostring(name or "")
        local jn = QN(n)
        if jn ~= n then n = jn elseif #n > 30 then n = string.sub(n, 1, 29) .. "." end
        imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], 1, n)
    end
    -- pause (retour a Pioneer 2) : ligne a part pour ne jamais etre coupee avec le nom de la quete
    if paused then imgui.TextColored(1.0, 0.75, 0.3, 1, T("[pause]")) end
    local r, g, b = 0.95, 0.97, 1.0
    if TM.colors and pb then
        if dur <= pb then r, g, b = 0.55, 1.0, 0.65 else r, g, b = 1.0, 0.62, 0.35 end
    end
    local txt = fmt(dur)
    pcall(imgui.SetWindowFontScale, TM.scale)
    local okx, x = pcall(imgui.GetCursorPosX)
    imgui.TextColored(r, g, b, 1, txt)
    if TM.bold and okx and type(x) == "number" then
        imgui.SameLine(x + 1)
        imgui.TextColored(r, g, b, 1, txt)
    end
    pcall(imgui.SetWindowFontScale, 1)
    if TM.pb then
        if pb then
            local d = dur - pb
            imgui.TextDisabled("PB " .. fmt(pb))
            imgui.SameLine(0, 10)
            if d <= 0 then
                imgui.TextColored(0.55, 1.0, 0.65, 1, "-" .. fmt(-d))
            else
                imgui.TextColored(1.0, 0.62, 0.35, 1, "+" .. fmt(d))
            end
        else
            imgui.TextDisabled(T("Pas encore de PB"))
        end
    end
end

local function draw_timer_window()
    local pushed = 0
    for _, c in ipairs({
        { "WindowBg", 0.05, 0.06, 0.11, TM.alpha / 100 },
        { "Border", 0.45, 0.55, 1.00, 0.85 },
    }) do
        if pcall(imgui.PushStyleColor, c[1], c[2], c[3], c[4], c[5]) then pushed = pushed + 1 end
    end
    pcall(imgui.SetNextWindowSize, 340, 130, "FirstUseEver")
    local flags = { "NoTitleBar", "NoScrollbar" }
    if TM.no_move then flags[#flags + 1] = "NoMove" end
    if TM.no_resize then flags[#flags + 1] = "NoResize" end
    local ok = imgui.Begin("Quest Timer", true, flags)
    if ok then
        local q = data[current.ep] and data[current.ep][run_key(current.id, current.diff, current.mode, current.ang)]
        local pb = q and (q.vbest or q.best) or nil
        if q and q.fbest and FREE[free_key(current.name)] then pb = q.fbest end
        local shown_dur = run_elapsed(current)
        if current.wait_start then shown_dur = 0 end
        -- Simulator 2.0 : le chrono reste a 0:00 tant que le message "Stage 1" n'est pas apparu
        if free_key(current.name) == "simulator20" and not current.sim_started then shown_dur = 0 end
        timer_body(current.name or "", shown_dur, pb, current.pause_since ~= nil)
    end
    imgui.End()
    for _ = 1, pushed do pcall(imgui.PopStyleColor) end
end

-- Onglet Timer : reglages + apercu
local function tm_toggle(label, key)
    if imgui.Checkbox(T(label), TM[key]) then
        TM[key] = not TM[key]
        save_settings()
    end
end

local function tm_stepper(label, key, step, lo, hi, fmt_str)
    imgui.Text(T(label))
    imgui.SameLine(220)
    if imgui.Button("-##tm_" .. key) then
        TM[key] = math.max(lo, TM[key] - step)
        save_settings()
    end
    imgui.SameLine(0, 8)
    imgui.Text(string.format(fmt_str, TM[key]))
    imgui.SameLine(0, 8)
    if imgui.Button("+##tm_" .. key) then
        TM[key] = math.min(hi, TM[key] + step)
        save_settings()
    end
end

local function draw_timer_tab()
    imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], 1, T("Reglages du timer"))
    imgui.Spacing()
    tm_toggle("Afficher le timer pendant une quete", "enabled")
    tm_toggle("Nom de la quete", "name")
    tm_toggle("PB et ecart en direct", "pb")
    tm_toggle("Chrono vert / orange selon le PB", "colors")
    tm_toggle("Chrono plus epais", "bold")
    tm_toggle("No move", "no_move")
    tm_toggle("No resize", "no_resize")
    tm_toggle("Pause du chrono a Pioneer 2", "p2_pause")
    imgui.TextDisabled(T("Par defaut, le temps passe a Pioneer 2 compte dans le chrono (Time Attack). Cocher pour le mettre en pause."))
    imgui.Spacing()
    tm_stepper("Taille du chrono", "scale", 0.2, 1.0, 4.0, "%.1f")
    tm_stepper("Opacite du fond (0-100)", "alpha", 10, 0, 100, "%d")
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()
    imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], 1, T("Apercu"))
    imgui.Spacing()
    timer_body("Mop-up Operation #1", 201, 240)
end

-- Onglet Time Attack / Personal Best : tableau en deux colonnes,
-- One Person Mode a gauche et Normal Mode a droite. Une quete par ligne (nom + difficulte),
-- et sous le nom : le nombre de fois, le PB et la moyenne de chaque mode.
local ta_diff = nil      -- filtre de difficulte (nil = toutes)
local ta_mode_idx = 3    -- menu deroulant : 1 = One Person, 2 = Normal, 3 = Tout (par defaut)

-- Boutons Tout / N / H / VH / Ult a cote de l'en-tete d'une colonne.
-- Renvoie le filtre (nil ou 0..3) apres le clic. Recliquer sur la difficulte active l'enleve.
local function draw_diff_filter(suffix, cur)
    local function btn(label, value)
        local active = (cur == value)
        if imgui.Button((active and ("[" .. label .. "]") or label) .. "##tadiff_" .. suffix .. label) then
            cur = (active and value ~= nil) and nil or value
        end
    end
    btn(T("Tout"), nil)
    for d = 0, 3 do
        imgui.SameLine(0, 6)
        btn(DIFF_NAMES[d], d)
    end
    return cur
end

local function draw_counters()
    -- stats[cle] = { name, diff, solo = {count,total,best}, normal = {...} }
    local stats = {}
    for ep = 0, 2 do
        for _, q in pairs(data[ep] or {}) do
            local k = ep .. "_" .. q.id .. "_" .. q.diff .. "_" .. (q.ang or 0)
            local s = stats[k]
            if not s then
                s = { name = q.name, diff = q.diff, ang = q.ang or 0 }
                stats[k] = s
            end
            s.name = q.name
            do
                local m = (q.mode == "solo") and "solo" or "normal"
                local c = s[m]
                if not c then
                    c = { count = 0, total = 0, best = nil }
                    s[m] = c
                end
                -- uniquement les runs valides (quete rendue)
                c.count = c.count + (q.done or 0)
                c.total = c.total + (q.dtotal or 0)
                if q.vbest and (not c.best or q.vbest < c.best) then c.best = q.vbest end
            end
        end
    end
    local query = string.lower(quest_search or "")
    local list = {}
    for _, s in pairs(stats) do
        if quest_matches(s.name, query) then
            list[#list + 1] = s
        end
    end
    table.sort(list, function(x, y)
        if x.name ~= y.name then return x.name < y.name end
        if x.diff ~= y.diff then return x.diff < y.diff end
        return x.ang < y.ang
    end)

    -- menu deroulant : un seul mode affiche a la fois
    local MODE_ITEMS = { T("One Person Mode"), T("Normal Mode"), T("Tout") }
    imgui.Text(T("Mode :"))
    imgui.SameLine(0, 8)
    imgui.PushItemWidth(180)
    local ok_combo, changed, idx = pcall(imgui.Combo, "##ta_mode", ta_mode_idx, MODE_ITEMS, #MODE_ITEMS)
    imgui.PopItemWidth()
    if ok_combo then
        if changed then ta_mode_idx = idx end
    else
        -- secours si le menu deroulant n'existe pas : un bouton qui alterne les deux modes
        if imgui.Button(MODE_ITEMS[ta_mode_idx] .. "##ta_mode_btn") then
            ta_mode_idx = (ta_mode_idx % #MODE_ITEMS) + 1
        end
    end
    local mode_key = (ta_mode_idx == 1) and "solo" or "normal"
    imgui.SameLine(0, 24)
    imgui.Text(T("Difficulte :"))
    imgui.SameLine(0, 8)
    ta_diff = draw_diff_filter("ta", ta_diff)
    imgui.TextDisabled(T("Seuls les runs valides (quete rendue) sont comptes ici."))
    imgui.Separator()
    imgui.Spacing()

    -- colonnes : nom | difficulte | nombre | PB | moyenne
    local X_DIFF, X_COUNT, X_PB, X_AVG, X_OK = 330, 430, 530, 670, 790
    imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], 1, T("Quete"))
    imgui.SameLine(X_DIFF)
    imgui.TextDisabled(T("Diff."))
    imgui.SameLine(X_COUNT)
    imgui.TextDisabled(T("Runs valides"))
    imgui.SameLine(X_PB)
    imgui.TextDisabled(T("PB"))
    imgui.SameLine(X_AVG)
    imgui.TextDisabled(T("Moyenne"))
    imgui.SameLine(X_OK)
    imgui.TextDisabled(T("Valide"))
    imgui.Separator()

    local shown = 0
    for _, s in ipairs(list) do
        local c = s[mode_key]
        if ta_mode_idx == 3 then
            -- les deux modes regroupes
            local a, b = s.solo, s.normal
            if a or b then
                c = { count = 0, total = 0, best = nil }
                for _, x in ipairs({ a or false, b or false }) do
                    if x then
                        c.count = c.count + x.count
                        c.total = c.total + x.total
                        if x.best and (not c.best or x.best < c.best) then c.best = x.best end
                    end
                end
            end
        end
        if c and c.count > 0 and (ta_diff == nil or ta_diff == s.diff) then
            shown = shown + 1
            imgui.Text(QN(s.name))
            imgui.SameLine(X_DIFF)
            imgui.TextColored(1, 0.8, 0.4, 1, (DIFF_NAMES[s.diff] or "?") .. (s.ang > 0 and (" Ang" .. s.ang) or ""))
            imgui.SameLine(X_COUNT)
            imgui.Text(string.format("x%d", c.count))
            imgui.SameLine(X_PB)
            imgui.TextColored(0.5, 1, 0.5, 1, fmt(c.best))
            imgui.SameLine(X_AVG)
            imgui.TextColored(0.7, 0.7, 0.7, 1, fmt(math.floor(c.total / c.count)))
            imgui.SameLine(X_OK)
            imgui.TextColored(0.4, 1, 0.5, 1, T("Valide"))
        end
    end
    if shown == 0 then
        imgui.TextDisabled(T(query ~= "" and "(aucune quete trouvee)" or "(aucun run valide)"))
    end

    -- Suivi libre : runs non termines inclus (quetes cochees dans la fenetre des monstres)
    local frees = {}
    for ep = 0, 2 do
        for _, q in pairs(data[ep] or {}) do
            local qm = (q.mode == "solo") and 1 or 2
            if (q.fcount or 0) > 0 and FREE[free_key(q.name)] and (ta_mode_idx == 3 or ta_mode_idx == qm)
               and (ta_diff == nil or ta_diff == q.diff) and quest_matches(q.name, query) then
                local k = q.name .. "_" .. q.diff .. "_" .. (q.ang or 0)
                local e = frees[k]
                if not e then
                    e = { name = q.name, diff = q.diff, ang = q.ang or 0, count = 0, total = 0 }
                    frees[k] = e
                end
                e.count = e.count + q.fcount
                e.total = e.total + (q.ftotal or 0)
                if q.fbest and (not e.best or q.fbest < e.best) then e.best = q.fbest end
            end
        end
    end
    local flist = {}
    for _, e in pairs(frees) do flist[#flist + 1] = e end
    if #flist > 0 then
        table.sort(flist, function(x, y)
            if x.name ~= y.name then return x.name < y.name end
            if x.diff ~= y.diff then return x.diff < y.diff end
            return x.ang < y.ang
        end)
        imgui.Spacing()
        imgui.Separator()
        imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], 1, T("Quete farm reset"))
        imgui.SameLine(0, 10)
        imgui.TextDisabled(T("(runs non termines inclus)"))
        imgui.Separator()
        for _, e in ipairs(flist) do
            imgui.Text(QN(e.name))
            imgui.SameLine(X_DIFF)
            imgui.TextColored(1, 0.8, 0.4, 1, (DIFF_NAMES[e.diff] or "?") .. (e.ang > 0 and (" Ang" .. e.ang) or ""))
            imgui.SameLine(X_COUNT)
            imgui.Text(string.format("x%d", e.count))
            imgui.SameLine(X_PB)
            imgui.TextColored(0.5, 1, 0.5, 1, fmt(e.best))
            imgui.SameLine(X_AVG)
            imgui.TextColored(0.7, 0.7, 0.7, 1, fmt(math.floor(e.total / e.count)))
        end
    end
end

local function present()
    update() -- le suivi des runs continue meme si la fenetre est fermee

    -- Le timer a sa propre fenetre, toujours visible pendant un run
    -- (Simulator 2.0 : le timer n'apparait qu'a partir du message "Stage 1")
    if current and TM.enabled
       and not (free_key(current.name) == "simulator20" and not current.sim_started) then
        draw_timer_window()
    end

    if not open then return end

    local success
    local theme_n = push_theme()
    success, open = imgui.Begin("Quest Tracker", open, { no_title and "NoTitleBar" or "" })
    if success then
        if last then
            imgui.TextColored(ACCENT[1], ACCENT[2], ACCENT[3], ACCENT[4], T("Dernier run : ") .. fmt(last.dur))
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                if last.completed then
                    imgui.Text(T("Run valide (quete terminee)"))
                elseif last.completed == nil then
                    imgui.Text(T("Verification en cours..."))
                else
                    imgui.Text(T("Run non valide : ") .. T(WHY_TEXT[last.why] or "?"))
                end
                imgui.EndTooltip()
            end
            imgui.Spacing()
        end

        -- Onglets (l'onglet actif est entre crochets) + "No title bar" a droite d'Historique
        tab_button(T("Liste de quete"), "list")
        imgui.SameLine(0, 10)
        tab_button(T("Historique"), "history")
        imgui.SameLine(0, 10)
        tab_button(T("Time Attack / Personal Best"), "counters")
        imgui.SameLine(0, 10)
        tab_button(T("Timer"), "timer")
        imgui.SameLine(0, 24)
        if imgui.Checkbox(Tb("No title bar"), no_title) then
            no_title = not no_title
            save_settings()
        end
        -- Langue : [FR] [EN], le bouton actif est colore
        imgui.SameLine(0, 24)
        for i, code in ipairs({ "fr", "en", "ja" }) do
            if i > 1 then imgui.SameLine(0, 6) end
            local n = 0
            if LANG == code then
                for _, name in ipairs({ "Button", "ButtonHovered", "ButtonActive" }) do
                    if pcall(imgui.PushStyleColor, name, TAB_ON[1], TAB_ON[2], TAB_ON[3], TAB_ON[4]) then n = n + 1 end
                end
            end
            if imgui.Button("[" .. (code == "ja" and "JP" or string.upper(code)) .. "]##lang_" .. code) then
                LANG = code
                save_settings()
            end
            pop_theme(n)
        end
        -- Profil : [Normal] [Sandbox] (donnees separees ; changement impossible pendant un run)
        imgui.SameLine(0, 24)
        for i, code in ipairs({ "normal", "sandbox" }) do
            if i > 1 then imgui.SameLine(0, 6) end
            local n = 0
            if PROFILE == code then
                for _, name in ipairs({ "Button", "ButtonHovered", "ButtonActive" }) do
                    if pcall(imgui.PushStyleColor, name, TAB_ON[1], TAB_ON[2], TAB_ON[3], TAB_ON[4]) then n = n + 1 end
                end
            end
            if imgui.Button((code == "normal" and "Normal" or "Sandbox") .. "##profile_" .. code) and not current then
                switch_profile(code)
            end
            pop_theme(n)
        end
        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()

        if current_tab == "counters" then
            draw_search_box("ta")

            imgui.Spacing()
            ang_button()
            imgui.SameLine(0, 24)
            imgui.SameLine(0, 24)
            if confirm_reset then
                imgui.Text(T("Tout remettre a 0 ?"))
                imgui.SameLine(0, 10)
                if imgui.Button(Tb("Oui")) then
                    data = {}
                    last = nil
                    confirm_reset = false
                    save()
                end
                imgui.SameLine(0, 10)
                if imgui.Button(Tb("Non")) then confirm_reset = false end
            else
                if imgui.Button(Tb("Reset")) then confirm_reset = true end
            end
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
        end

        if current_tab == "history" then
            draw_history()
        end

        if current_tab == "list" then
            draw_quest_list()
        end

        if current_tab == "counters" then
            draw_counters()
        end

        if current_tab == "timer" then
            draw_timer_tab()
        end
    end
    imgui.End()
    draw_mobs_window()
    pop_theme(theme_n)
end

-- Migration : reconstruit les stats Time Attack (runs valides) depuis l'historique
local function migrate_stats()
    for _, quests in pairs(data) do
        for _, q in pairs(quests) do
            if q.dtotal == nil then
                q.done, q.dtotal, q.vbest = 0, 0, nil
                for _, h in ipairs(history) do
                    if h.ok and h.name == q.name and h.diff == q.diff and h.mode == q.mode and (h.ang or 0) == (q.ang or 0) then
                        credit_validated(q, h.dur)
                    end
                end
            end
        end
    end
    save()
end

function switch_profile(p)
    if p == PROFILE then return end
    save()
    save_history()
    PROFILE = p
    apply_profile_paths()
    data = {}
    for i = #history, 1, -1 do history[i] = nil end
    last = nil
    load_data()
    load_history()
    migrate_stats()
    save_settings()
end

local function init()
    load_settings() -- d'abord : donne le profil, donc les fichiers a charger
    load_data()
    load_history()
    migrate_stats()
    load_phrases()
    core_mainmenu.add_button("Quest Tracker", function() open = not open end)
    return {
        name = "Quest Tracker",
        version = "1.1",
        author = "Ratalix",
        description = "Compteur de runs, temps et PB par épisode",
        present = present,
    }
end

return { __addon = { init = init } }
