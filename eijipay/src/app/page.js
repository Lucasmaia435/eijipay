import styles from "./page.module.css";
import loginStyle from "./login/login.module.css";

export default function Login() {
  return (
    <div className={styles.page}>
      <main className={styles.main}>
      <div className={loginStyle.card}>
          <h2>Bem-vindo<br/>ao<br/>EijiPay</h2>
          <form className={styles.form}>
              <div className={styles.inputGroup}>
                  <input type="email" id="email" name="email" placeholder="Digite seu e-mail" required />
              </div>
              <div className={styles.inputGroup}>
                  <input type="password" id="password" name="password" placeholder="Digite sua senha" required />
              </div>
              <button type="submit" className={styles.primary_button}>Fazer Login</button>
              
              
              <a href="/register" className={styles.link}>
                  Não tem uma conta? Cadastre-se
              </a>
          </form>
      </div>
      </main>
    </div>
  );
}
