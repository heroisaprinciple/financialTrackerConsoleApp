require "pg"

module FinancialTrackerConsoleApp

  class FinancialTrackerPurchaseRepo
    def initialize
      begin
        @db_connection = PG.connect(dbname: 'financialTracker', host: 'localhost',
                                    user: ENV['DBI_USER'], password: ENV['DBI_PASSWORD'])
      rescue
        puts 'Can not connect to the db'
      end

    end

    def finalize # destructor
      if @db_connection
        @db_connection.disconnect
      end

    end

    def add_entity(name, price, date, user_id, category_id)
      if date == ''
        date = nil
      end

      @db_connection.exec_params('INSERT INTO "purchases"(name, price, date, user_id, category_id) VALUES($1, $2, $3, $4, $5)', [name, price, date, user_id, category_id])
    end

    def add_category(name)
      res = @db_connection.exec_params('INSERT INTO "category"(name) VALUES($1) RETURNING id', [name])

      # returns id
      res.getvalue(0, 0)
    end

    def get_categories
      hash = {}
      res = @db_connection.exec('SELECT * FROM "category" ') # array of an objects

      res.each do |el|
        hash[el['id']] = el['name']
      end

      hash
    end

    def get_purchases(user_id, category_id, date)
      sql = 'SELECT p.name, p.price, p.date, c.name AS category_name FROM "purchases" p ' +
        'LEFT JOIN "category" c ON p.category_id = c.id ' +
        "WHERE p.user_id = #{user_id} "

      if category_id
        sql = sql + "AND p.category_id = #{category_id} "
      end

      if date
        # DATEDIFF compares dates
        # $3 is a parameter in the func (day, month or year)
        # date is a date in the table
        sql = sql + "AND p.date IS NOT NULL AND DATE_PART('#{date}', CURRENT_DATE) - DATE_PART('#{date}', date) = 0"
      end

      res = @db_connection.exec(sql)

      return res
    end

    def clear(user_id)
      @db_connection.exec_params('DELETE FROM "purchases" WHERE user_id = $1', [user_id])
    end

  end

end