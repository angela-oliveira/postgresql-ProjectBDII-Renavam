
/*Para verificar o seu Host ,port etc 

Acesse o postgres click com botão direito e vá em connection

obs: se senha utilizda é a mesma que foi escolhida,quando foi feita a instalação do seu postgres na sua máquina. 

*/



import psycopg2
try:

    conn = psycopg2.connect(

        host='localhost',
        port=5434, 
        database='ProjetoBD2',
        user='postgres',
        password='cstsihj'
    )
    print('Sucesso na conexão')

    cursor = conn.cursor()
    cursor.execute('SELECT renavam,placa from veiculo')

    rows = cursor.fetchall()

    for r in rows:
        print(f"id {r[0]} placa {r[1]}")

    cursor.close()

    conn.close()
except:
    print('Erro na conexão com o banco de dados')
