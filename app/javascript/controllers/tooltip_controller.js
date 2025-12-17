import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "content"];

  connect() {
    // 【重要】読み込み直後に「画面固定」かつ「画面外」へ飛ばす
    // これにより、ホバー時の position 切り替えによる画面揺れを完全になくします
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      top: "-9999px",
      left: "-9999px",
      zIndex: "100",
      width: "auto", // HTMLのクラス(w-96)を活かすためautoにしない手もありますが、崩れるならここを調整
    });

    // 初期状態は非表示
    this.hide();
  }

  show() {
    if (this.timeout) {
      clearTimeout(this.timeout);
    }

    // すでに fixed になっているので、そのままサイズ計測してOK
    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();

    // 座標計算
    const top = triggerRect.top - contentRect.height - 10;
    const left =
      triggerRect.left + triggerRect.width / 2 - contentRect.width / 2;

    // 座標適用
    this.contentTarget.style.top = `${top}px`;
    this.contentTarget.style.left = `${left}px`;

    this.contentTarget.classList.remove("invisible", "opacity-0");
  }

  hide() {
    // マウスが隙間を通るための猶予時間
    this.timeout = setTimeout(() => {
      this.contentTarget.classList.add("invisible", "opacity-0");

      // 【重要】フェードアウト後に画面外へ戻す（誤クリック防止）
      // transition(200ms)が終わった後に移動させる
      setTimeout(() => {
        // 表示中でなければ（マウスが戻ってきてなければ）画面外へ
        if (this.contentTarget.classList.contains("invisible")) {
          this.contentTarget.style.top = "-9999px";
          this.contentTarget.style.left = "-9999px";
        }
      }, 200);
    }, 100);
  }
}
