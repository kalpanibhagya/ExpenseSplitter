class EventController < ApplicationController 
  def index
    check_user

    user_id = current_user.id

    @debts =  Event.joins(:transactions).where('transactions.sender_id = ? AND transactions.settle= ?',user_id,false).order(created_at: :desc).group('event_id')
    @spents =  Event.joins(:transactions).where('transactions.receiver_id = ? AND transactions.settle= ?',user_id,false).order(created_at: :desc).group('event_id')
    @settlements =  Event.joins(:transactions).where('(transactions.sender_id = ? OR transactions.receiver_id = ?) AND transactions.settle= ?',user_id,user_id,true).order(created_at: :desc).group('event_id')

  end

  def new
    check_user

    @event = Event.new
    @user = current_user
    @event.participates = Array.new

    # Add event creator(logged user) as a participate
    self_participate = Participate.new
    self_participate.user = @user
    @event.participates.push(self_participate)

    @results = @user.friends
  end

  def create
    check_user
    @event = Event.new(event_params)
    if @event.save
      create_transactions(@event)
      flash[:notice] = "Successfully created event."
      redirect_to event_path(@event.id)
    else
      flash[:notice] = "Event creation error"
      render :action => 'new'
    end
  end

  def show
    check_user
    @event = Event.includes(:participates, :transactions).find(params[:id])
  end

  def transaction_settle

    transaction = Transaction.find(params[:transaction_id])
    # check for unauthorized access
    if (transaction.receiver.id == current_user.id) 

      transaction.settle = true
      transaction.save

      message = "I settled your payment of #{transaction.amount} to the event \"#{transaction.event.name}\""
      link = Notification.get_link(transaction.event) 
      Notification.add_notification(transaction.receiver,transaction.sender,message,link)

      flash[:notice] = "Notificatin sent to #{transaction.receiver.name}"

      redirect_to event_path(params[:id])
    else
      flash[:notice] = "You are not authorized to settle this transactoin"
      redirect_to event_path(params[:id])
    end
  end

  def transaction_remind
    transaction = Transaction.find(params[:transaction_id])

    message = "Please settle my payment of #{transaction.amount} to the event \"#{transaction.event.name}\""
    link = Notification.get_link(transaction.event) 
    Notification.add_notification(transaction.sender,transaction.receiver,message,link)

    flash[:notice] = "Notificatin sent to #{transaction.receiver.name}"

    redirect_to event_path(params[:id])
  end


  def new_participant
    @participant = Participate.new
    @participant.user = User.find(params[:format])
    # puts 'new_participant called'
    # puts participant.inspect
  end

  def search_friend
    @results = User.search(params[:search],params[:participant_ids])

    if(@results == nil || @results.length == 0)
      @results = current_user.friends
    end

    puts @results.inspect

    puts " Found results: #{ @results.length }"
  end

  def create_transactions(event)
    if(event != nil && event.participates != nil)

      # find sum of portion and total amount
      total_amount = 0.0;
      total_portion = 0.0;
      event.participates.each do |participate|
       total_amount = total_amount + participate.amount
       total_portion = total_portion + participate.portion
     end

     unit_portion_amount = total_amount / total_portion

      # init TransactionCalc 
      calc_list = Array.new
      event.participates.each do |participate|
       calc = TransactionCalc.new
       calc.user = participate.user
       calc.portion = participate.portion * unit_portion_amount
       calc.put = participate.amount
       calc.pay = calc.portion - calc.put

       calc_list.push(calc)
     end

      # init Transaction List
      transaction_list = Array.new
      all_zero = false
      interate = 0;
      while(!all_zero) do
       all_zero = true
       calc_list.each do |first|
          #make continue if first.pay = 0 (already stable)
          next if (first.pay == 0)

          calc_list.each do |second|
            #make continue if second.pay = 0 (already stable)
            next if (second.pay == 0)

            first_pay = first.pay
            second_pay = second.pay
            sum = first_pay + second_pay
            if(first.user != second.user && first_pay > 0 && second_pay < 0)
             transac = Transaction.new
             transac.event = event
             transac.sender = first.user
             transac.receiver = second.user
             transac.settle = false
             if(sum >= 0 )
                # first => second : second.pay (first pays second an {second.pay} amount)
                puts "#{first.user.first_name} pays #{second.user.first_name} amount #{ second.pay.abs }"
                transac.amount = second.pay.abs

                first.pay = sum
                second.pay = 0
              else
                # first => second : first.pay
                puts "#{first.user.first_name} pays #{second.user.first_name} amount #{ first.pay.abs }"
                transac.amount = first.pay.abs

                first.pay = 0
                second.pay = sum
              end

              transaction_list.push(transac)

            end


          end

          # 0.0000 fix for amount with infinite digits. precision of 0.000
          if(all_zero && first.pay >= 0.0001)
            all_zero = false
          end
        end
      end

      Transaction.save_all(transaction_list)

    end
  end

  def check_user
    @user = current_user
    if (@user == nil)
      flash[:notice] = "Please Sign In to access"
      redirect_to root_path
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, participate_attributes: [:user_id,:amount,:portion])
  end

end