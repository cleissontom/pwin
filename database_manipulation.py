import pandas.io.sql as psql
import psycopg2
import io
import pandas as pd

from sqlalchemy import create_engine
from credentials import Credentials

class Database_Manipulation:
    def __init__(self):
        self.init = Credentials()

    '''
    Function prepare string connection from python and database
    This function only work if there are a script 'credential.py' in the same folder
    credential.py contains pass and user to access database

    input: ''
    output: string formatted to connection database
    '''
    def parameters(self):

        init = Credentials()

        # parameters database
        server = init.server
        db = init.db
        user = init.user
        passw = init.passw

        stringConnect = 'postgresql://' + user + ":" + passw + '@' + server + ':5432' + '/' + db
        # print(stringConnect)

        return (stringConnect)

    '''
    Function was used to extract all rows from table

    input: table_name
    columns: list for all columns that will be extracted, default all columns
    output: pandas dataframe with all rows table without any filter
    '''
    def extract_all_rows_table(self,schema_name, table_name, columns=None):


        if columns is None:
            stringExtract = "select * from " + str(schema_name) + "."+ str(table_name)
        else:
            stringExtract = "select " + ','.join(columns) + ' from ' + str(schema_name) + "."+ str(table_name)

        string_connection = self.parameters()

        engine = create_engine(string_connection)
        df = pd.read_sql_query(stringExtract, engine)

        engine.dispose()

        return (df)

    '''
    Function to extract rows from table with specific filter in column
    The function execute just 1 filter by column

    input:
        schema_name: name of schema
        table_name: name of table
        column_filter: name of column will be filter
        value_filter: value of filter
        columns_show: list for all columns that will be extracted, default is all columns
        special_case_for_date: boolean option to filter all rows by a date NOT FOR TIMESTAMP, JUST USE FOR DATE FILTER

    output:
        pandas dataframe with rows extracted for schema and table specified

    '''
    def extract_rows_one_filtered(self,schema_name, table_name, column_filter
                                  , value_filter
                                  , special_case_for_date=False
                                  , columns_show=None):

        type_column_filter = ""

        string_sql_initial = " select data_type from information_schema.columns " + \
                             " where table_schema = '" + schema_name + "'" + \
                             " and table_name = '" + table_name + "'" \
                                                                  " and column_name = '" + column_filter + "';"

        # print(string_sql_initial)

        string_connection = self.parameters()
        engine = create_engine(string_connection)

        result = engine.execute(string_sql_initial)
        for row in result:
            type_column_filter = row['data_type']

        # when column is type text we need to include simple ' in first character and last character
        if (type_column_filter == ""):
            print("Error! There are not table in database with these parameters")
            return (pd.DataFrame())
        elif ((type_column_filter == "character varying") | ("timestamp" in type_column_filter)):
            value_filter = "'" + value_filter + "'"

        if columns_show is None:
            if special_case_for_date:
                string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date = " + str(value_filter) + ""
            else:
                string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + " = " + str(value_filter) + ""
        else:
            if special_case_for_date:
                string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date = " + str(value_filter)
            else:
                string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date = " + str(value_filter)

        # print(string_sql)

        df = pd.read_sql_query(string_sql, engine)

        engine.dispose()

        return (df)

    '''
    Function to extract rows from table with specific filter in column
    The function execute for ONE column
    This function will be able to extract rows considered multiple values in filter


    input:
        schema_name: name of schema
        table_name: name of table
        column_filter: name of column will be filter
        value_filter: value of filter, maybe a list of single value
        columns_show: list for all columns that will be extracted, default is all columns
        special_case_for_date: boolean option to filter all rows by a date NOT FOR TIMESTAMP, JUST USE FOR DATE FILTER

    output:
        pandas dataframe with rows extracted for schema and table specified
    '''
    def extract_rows_table_multiple_values(self,schema_name, table_name, column_filter
                                  , value_filter
                                  , special_case_for_date=False
                                  , columns_show=None):


        value_in_list=False

        if (type(columns_show)==list):
            if(columns_show[0] == '*'):
                columns_show = None
        else:
            if(columns_show=='*'):
                columns_show = None


        if (type(value_filter)==list):
            value_in_list = True

            if (len(value_filter) == 0):
                print("Error! empty value of parameters")
                return (pd.DataFrame())

            elif(len(value_filter)>0):
                if (type(value_filter[0])==str):
                    value_filter = "\'" + '\',\''.join(value_filter) + "\'"
                else:
                    value_filter = ','.join([str(elem) for elem in value_filter])
        else:
            if (type(value_filter)==str):
                value_filter = "'"+value_filter+"'"

            if (value_filter==""):
                print("Error! empty value of parameters")
                return (pd.DataFrame())

        string_connection = self.parameters()
        engine = create_engine(string_connection)

        if columns_show is None:
            if special_case_for_date:
                if value_in_list:
                    string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date in (" + str(value_filter) + ")"
                else:
                    string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date = " + str(value_filter) + ""
            else:
                if value_in_list:
                    string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                                 " where " + column_filter + " in (" + str(value_filter) + ")"
                else:
                    string_sql = "select * from " + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + " = " + str(value_filter) + ""
        else:
            if special_case_for_date:
                if value_in_list:
                    string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + \
                                 str(table_name) + " where " + column_filter + "::date in ( " + str(value_filter) + ");"
                else:
                    string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + "::date = " + str(value_filter)
            else:
                if value_in_list:
                    string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + \
                                 str(table_name) + " where " + column_filter + \
                                 " in ( " + str(value_filter) + ");"
                else:
                    string_sql = "select " + ','.join(columns_show) + ' from ' + str(schema_name) + "." + str(table_name) + \
                             " where " + column_filter + " = " + str(value_filter)

        #print(string_sql)

        df = pd.read_sql_query(string_sql, engine)


        engine.dispose()

        return (df)

    '''
    Function was used to extract all rows from table using string "where" to filter specific sentence

    input: table_name
    string where, example " where id=10 and symbol = 30 "
    columns: list for all columns that will be extracted, default all columns

    output: pandas dataframe with all rows table without any filter
    '''
    def extract_all_rows_table_string_where(self,schema_name, table_name, string_where, columns=None):


        if columns is None:
            stringExtract = "select * from " + str(schema_name) + "."+ str(table_name) +\
                " " +  str(string_where)

        else:
            stringExtract = "select " + ','.join(columns) + ' from ' + str(schema_name) + "."+ str(table_name) +\
                    " " + str(string_where)

        string_connection = self.parameters()

        engine = create_engine(string_connection)
        df = pd.read_sql_query(stringExtract, engine)

        engine.dispose()

        return (df)


    def execute_string(self,string_to_execute):



        string_connection = self.parameters()
        engine = create_engine(string_connection)

        try:
            connection = engine.connect()
            trans = connection.begin()
            connection.execute(string_to_execute)
            trans.commit()
            trans.close
        except:
            print("Error! string try to execute")
            print(string_to_execute)


    def df_to_new_table_postgres(self,df, new_table, if_exists='fail', sep='\t', encoding='utf8'):


        string_connection = self.parameters()

        engine = create_engine(string_connection)

        # Create Table
        df[:0].to_sql(new_table, engine, if_exists=if_exists)

        # Prepare data
        output = io.StringIO()
        df.to_csv(output, sep=sep, header=False, encoding=encoding)
        output.seek(0)

        # Insert data
        connection = engine.raw_connection()
        cursor = connection.cursor()
        cursor.copy_from(output, new_table, sep=sep, null='')
        connection.commit()
        cursor.close()


    def execute_select_by_string(self, string_execute):
        # import pandas.io.sql as psql
        # import psycopg2
        # init = Credentials()
        try:
            con = psycopg2.connect(database = self.init.db,
                               user = self.init.user,
                               password = self.init.passw,
                               host = self.init.server,
                               port = "5432")
            df = psql.read_sql(string_execute, con)
            return df
        except:
            return (pd.DataFrame())



