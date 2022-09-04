require "pg"

module FinancialTrackerConsoleApp

  class FinancialTrackerUserRepo
    def initialize
      begin
        @db_connection = PG.connect(dbname: 'financialTracker', host: 'localhost',
                                    user: ENV['DBI_USER'], password: ENV['DBI_PASSWORD'])
      rescue
        puts 'Can not connect to the db'
      end

    end

    def register(first_name, last_name, email, password)
      # preparing for making the command

      # $1, $2 amd etc means values that will be automatically changed
      begin
        res = @db_connection.exec_params('INSERT INTO "user"(first_name, last_name, email, password) VALUES($1, $2, $3, PGP_SYM_ENCRYPT($4, $5)) RETURNING id;', [first_name, last_name, email, password, ENV['tracker_secret']])
        # the last param is the secret key for the password

        # returning id
        return res.getvalue(0, 0)

      rescue
        return -1
      end

    end

    def login(email, password)

        # decryption of a password and then comparing it with what user used
        res = @db_connection.exec_params('SELECT id FROM "user" WHERE email = $1 AND PGP_SYM_DECRYPT(password::bytea, $3) = $2', [email, password, ENV['tracker_secret']])

        return res.getvalue(0, 0)

    end


    def finalize # destructor
      if @db_connection
        @db_connection.disconnect
      end

    end
  end

end