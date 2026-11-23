
import getpass
import pyodbc

from werkzeug.security import generate_password_hash


# SQL Server baglantisi
CONNECTION_STRING = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    r"SERVER=(localdb)\MSSQLLocalDB;"
    "DATABASE=Societas;"
    "Trusted_Connection=yes;"
    "Encrypt=no;"
)

FULL_NAME = "Test Coordinator"
EMAIL = "coordinator.test@societas.local"
ROLE_NAME = "Student Affairs Coordinator"


def main():
    password = getpass.getpass("Koordinator test parolasi: ")
    confirmation = getpass.getpass("Parolayi tekrar girin: ")

    if not password:
        print("HATA: Parola bos olamaz.")
        return

    if password != confirmation:
        print("HATA: Parolalar eslesmiyor.")
        return

    # Parolayi guvenli bicimde ozetle.
    password_hash = generate_password_hash(
        password,
        method="scrypt"
    )

    # Duz metin parolayi artik kullanmiyoruz.
    del password
    del confirmation

    connection = None

    try:
        connection = pyodbc.connect(
            CONNECTION_STRING,
            autocommit=False
        )

        cursor = connection.cursor()

        # E-posta daha once kullanilmis mi?
        cursor.execute(
            """
            SELECT UserID
            FROM dbo.Users
            WHERE Email = ?
            """,
            EMAIL
        )

        existing_user = cursor.fetchone()

        if existing_user:
            raise RuntimeError(
                "Bu e-posta adresi zaten kullaniliyor. "
                "Mevcut hesabi otomatik olarak degistirmedim."
            )

        # Koordinator rolunu bul.
        cursor.execute(
            """
            SELECT RoleID
            FROM dbo.Roles
            WHERE RoleName = ?
            """,
            ROLE_NAME
        )

        role = cursor.fetchone()

        if role is None:
            raise RuntimeError(
                "Student Affairs Coordinator rolu bulunamadi."
            )

        role_id = role[0]

        # Kullanici hesabini olustur.
        cursor.execute(
            """
            INSERT INTO dbo.Users
                (FullName, Email, PasswordHash, IsActive)
            OUTPUT INSERTED.UserID
            VALUES (?, ?, ?, 1)
            """,
            FULL_NAME,
            EMAIL,
            password_hash
        )

        user_id = cursor.fetchone()[0]

        # Koordinator rolunu ata.
        cursor.execute(
            """
            INSERT INTO dbo.UserRoles
                (UserID, RoleID, AssignedAt)
            VALUES (?, ?, SYSDATETIME())
            """,
            user_id,
            role_id
        )

        connection.commit()

        print("\nKoordinator hesabi basariyla olusturuldu.")
        print(f"UserID: {user_id}")
        print(f"Ad: {FULL_NAME}")
        print(f"E-posta: {EMAIL}")
        print(f"Rol: {ROLE_NAME}")
        print("Parola ozeti veritabanina kaydedildi.")

    except Exception as error:
        if connection is not None:
            connection.rollback()

        print(f"\nISLEM BASARISIZ: {error}")

    finally:
        if connection is not None:
            connection.close()


if __name__ == "__main__":
    main()
