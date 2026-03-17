import streamlit as st
import time
from datetime import date

# 頁面配置 (必須放在第一行)
st.set_page_config(page_title="通用旅遊助手", layout="wide")

# --- 1. 開場動畫邏輯 ---
if 'animation_done' not in st.session_state:
    # 建立一個全螢幕的淺藍色背景容器
    placeholder = st.empty()
    with placeholder.container():
        st.markdown(
            """
            <style>
            .welcome-bg {
                background-color: #E0F2F7;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
            }
            .welcome-text {
                font-size: 50px;
                color: #2C3E50;
                font-family: 'Microsoft JhengHei', sans-serif;
            }
            </style>
            <div class="welcome-bg">
                <div class="welcome-text">歡迎回來 👋</div>
            </div>
            """,
            unsafe_allow_html=True
        )
    time.sleep(2)  # 停留 2 秒
    placeholder.empty()  # 清除動畫
    st.session_state.animation_done = True

# --- 2. 主頁面內容 (三大區塊) ---
if st.session_state.get('animation_done'):
    st.title("🧳 我的旅遊儀表板")
    st.divider()

    # 使用 columns 達成橫向均分
    col1, col2, col3 = st.columns(3)

    # 第一部分：歷史行程 (Past)
    with col1:
        st.subheader("📜 歷史行程")
        # 這裡未來會接 Supabase 查詢 (WHERE end_date < today)
        with st.expander("點擊展開過去的回憶"):
            # 模擬資料顯示
            st.info("📍 2025 東京賞櫻 (2025-03-20 ~ 03-25)")
            st.info("📍 2024 泰國避暑 (2024-07-10 ~ 07-15)")

    # 第二部分：規劃中行程 (Ongoing/Future)
    with col2:
        st.subheader("🗓️ 規劃中行程")
        # 這裡未來會接 Supabase 查詢 (WHERE end_date >= today)，按日期升冪排序
        with st.expander("點擊查看即將到來的冒險", expanded=True):
            st.success("🏖️ 2026 邦勞島潛水 (2026-01-17 ~ 01-22)")
            st.caption("💡 距離出發還有 300 多天")

    # 第三部分：建立新的行程 (New)
    with col3:
        st.subheader("➕ 建立新行程")
        with st.container(border=True):
            # 第一列：Icon 與 名稱
            r1_c1, r1_c2 = st.columns([1, 3])
            with r1_c1:
                selected_icon = st.selectbox("圖示", ["✈️", "🏖️", "🎿", "🏙️", "🏔️"])
            with r1_c2:
                trip_name = st.text_input("行程名稱", placeholder="例如：2026 歐洲巡禮")

            # 第二列：日期選擇器
            start_date = st.date_input("開始日期", value=date.today())
            end_date = st.date_input("結束日期", value=date.today())

            # 建立按鈕
            if st.button("確認建立行程", use_container_width=True):
                st.balloons()
                st.write(f"已建立：{selected_icon} {trip_name}")
                # 這裡未來會接 Supabase INSERT