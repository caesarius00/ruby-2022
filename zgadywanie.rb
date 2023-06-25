#new function
def printBestScores(bestScore)
    #wyświetl najlepsze 5 wyników
    #lub więcej jeśli mają taki sam wynik (nie więcej niż 20)
    file = File.open("scores.txt", "r")
    lines = file.readlines[0..19]
    file.close
    #kolor złoty
    print "\e[33m"
    puts "\nNajlepsze wyniki:"
    print "\e[0m"

    #formatowanie wyjścia
    lines.map! { |line| line.split }
    lines.map! { |line| line[0] + "\t" + line[1] + "\t\t" + line[2] }
    
    #pogrubiony tekst
    print "\e[1m"
    puts "Imię\tLiczba prób\tData"
    print "\e[0m"

    #wypisywanie dopóki wyniki są takie same lub nie wypisano 5 wyników
    i = 0
    lines.each_with_index do |line, index|

        #kolor zielony
        print "\e[32m"
        #jeśli wynik jest najlepszy, wyświetl na niebiesko
        if line.split[1].to_i == bestScore
            print "\e[34m"
        end
        if index==0
            puts line
        elsif lines[index-1].split[1] == line.split[1] || i<5
            puts line
        else
            print "\e[0m"
            break
        end
        i+=1
        print "\e[0m"
    end
end

def getBestScore()
    #odczyt najlepszego wyniku (tylko punktów z 1 linii)
    #jeśli plik nie istnieje lub nie ma żadnych wyników, ustaw najlepszy wynik na 0
    begin
        file = File.open("scores.txt", "r")
        bestScore = file.readline.split[1].to_i
        file.close
    rescue
        #max int
        bestScore = 2**32-1
    end
    return bestScore
end

def notGuessedMessage(tries)
    #kolor czerwony
    print "\e[31m"

    case tries
    when 1
        puts "Jednak nie..."
    when 2
        puts "Znowu pudło!"
    when 3
        puts "Nie, nie, nie..."
    when 4
        puts "Nie, nie, nie, nie..."
    when 5
        puts "Eh... Nie!"
    when 6
        puts "..."
    when 7
        puts "Już nawet nie będę tego komentował..."
    when 10
        puts "Jeszcze grasz?"
    when 12
        puts "Ja już bym się dawno znudził..."
    when 15
        puts "Nie porzucaj nadzieje,\nJakoć sie kolwiek dzieje\n~Jan Kochanowski"
    when 20
        #kursywa
        print "\e[3m"
        puts "\"dni nasze jak cień na ziemi [mijają] bez żadnej nadziei\" \n ~1 Krn 29, 15b "
    when 25
        puts "Minęło już życie, z nim plany i dążenia mojego serca. \n ~Hi 17, 11"
    end

    print "\e[0m"

end

def finalMessage(tries)
    case tries
    when 1
        #niebieski
        print "\e[34m"
        puts "BRAWO! Jesteś mistrzem! Tylko jedna próba!"
        print "\e[0m"
    when 2..7
        #zielony
        print "\e[32m"
        puts "NIESAMOWITE! Liczba prób: #{tries}"
        print "\e[0m"
    when 8..14
        #żółty
        print "\e[33m"
        puts "Mogło być gorzej. Liczba prób: #{tries}"
        print "\e[0m"
    when 15..21
        #pomarańczowy
        print "\e[31m"
        puts "Tak źle to długo nie było... \n\tLiczba prób: #{tries}"
        print "\e[0m"
    else
        #czerwony
        print "\e[31m"
        puts "Przyznaj się - zero starania. \n\tLiczba prób: #{tries}"
        print "\e[0m"
    end
end

def checkIfRecord_Message(tries, bestScore)
    #jeśli wynik jest lepszy niż najlepszy, podświetl go
    if tries<bestScore && bestScore != 2**32-1
        #żółty
        print "\e[33m"
        puts "Nowy rekord! Poprzedni wynik: #{bestScore}"
        print "\e[0m"
        bestScore = tries
    elsif tries<bestScore
        print "\e[32m"
        puts "Nowy rekord!"
        print "\e[0m"
        bestScore = tries
    elsif tries==bestScore
        #niebieski
        print "\e[34m"
        puts "\tTak samo dobrze jak najlepszy wynik! Gratulacje!"
        print "\e[0m"
    elsif tries<bestScore+3
        #zielony
        print "\e[32m"
        puts "\Prawie tak dobrze jak rekord (#{bestScore})!\n\tMoże następnym razem się uda!"
        print "\e[0m"
    end
    return bestScore
end

def saveScore(name, tries)
    file = File.open("scores.txt", "a")
    file.puts "#{name} #{tries} #{Time.now.strftime("%d.%m.%Yr.")}"
    file.close

    #posortuj wyniki
    file = File.open("scores.txt", "r")
    lines = file.readlines
    file.close
    lines.sort! { |a, b| a.split[1].to_i <=> b.split[1].to_i }

    #zapisz posortowane wyniki do pliku
    file = File.open("scores.txt", "w")
    lines.each { |line| file.puts line }
    file.close
end

bestScore = getBestScore()

#gra

zakres = 500 ############################## zmień zakres tutaj

# "czyszczenie ekranu"
puts "\e[H\e[2J"
#kolor menu: cyan
print "\e[36m"
puts "Wylosowałem dla Ciebie liczbę (0-#{zakres}). Ile prób zajmie Ci zgadnięcie? \n\tJeśli chcesz zakończyć rozgrywkę\e[3m\e[34m (nie wiem jakim cudem)\e[0m\e[36m, po prostu napisz \e[1mkoniec"
print "\e[0m"
numberToSearch = rand(zakres)

#złoty
print "\e[33m"
print "\nMoże się uda za pierwszym razem?? : "
print "\e[0m"
#żółty
print "\e[33m"
x = gets
a = x.to_i
tries = 1
while a!=numberToSearch #&& x!="cheat\n" #cheat - kod na oszukanie systemu xD
    #reset koloru
    print "\e[0m"
    if x=="koniec\n" || x=="Koniec\n" || x=="KONIEC\n"
        puts "Żegnam!"
        return
    end
    
    notGuessedMessage(tries)

    tries+=1

    if a>numberToSearch
        #niebieski
        print "Liczba jest \e[34m\e[1mZA DUŻA! \e[0m"
    else
        #jasny pomarańczowy
        print "Liczba jest \e[31m\e[1mza mała! \e[0m"
    end
    puts "Spróbuj jeszcze raz!"
    print ": "
    #żółty
    print "\e[33m"
    x = gets
    a = x.to_i
end

#czyszczenie ekranu
puts "\e[H\e[2J"

finalMessage(tries)

bestScore = checkIfRecord_Message(tries, bestScore)

puts "Podaj swoje imię: "
#pogrubiony niebieski
print "\e[34m\e[1m"
#ignoruj więcej niż 1 słowo
name = gets.split[0]
saveScore(name, tries)

printBestScores(bestScore)

#żółty
print "\e[33m"
puts "\nTwój wynik #{name} to #{tries} prób(y)."
puts "Zgadywałeś liczbę #{numberToSearch}."
print "\e[0m"

#czy gramy dalej?
answearedCorrectly = false 
while !answearedCorrectly
    puts "\nCzy chcesz zagrać jeszcze raz? [T/n]"
    x = gets
    if x=="t\n" || x=="T\n" || x=="\n"
        load "zgadywanie.rb"
        answearedCorrectly = true
    elsif x=="n\n" || x=="N\n"
        #light blue
        print "\e[36m"
        puts "Szkoda, mam nadzieję, że wrócisz! :'("
        print "\e[0m"
        answearedCorrectly = true
    end
end