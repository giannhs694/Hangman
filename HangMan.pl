 start:-
	write("Welcome to Hangman by JP"),nl,nl,
	write('================================================'),nl,
	write('Player1 picks a word...'),nl,
	read(Answer),
	Lives = 6,Used=[],
	%O P1 epilegei thn leksi, theoroume oti h leksh apoteleite 
	%mono apo grammata peza.
	write('Player2 now has 6 chances of finding the hidden '),nl,
	write('word by guessing letters or the word itself...gl'),nl,
	%Dimiourgw tin krimmeni leksi
	string_chars(Answer,[H|T]),
	length([H|T],L), 
		%briskoume to length tis leksis mas kai
	%xrisimopoioume thn create_hidden_word gia na ftiaksoume tin krimeni leksi
	%write("The secret word to find : "),
	%create_hidden_word([H|T],L,ListHword),
		First=H,
		last([H|T],Last),letterFoundFirstLast([H|T],First,Last,[],ListHword),
	game(Guess,Lives,[H|T],ListHword,Used,L).


game(Guess, Lives, [H|T], ListHword, Used,L):-
	atomic_list_concat(ListHword,' ',Hword) ,%mono kai mono gia na emfanizw tin leksi san string
	(Lives==0 -> write("0 lives, GAME OVER");	
	 (ListHword=[H|T] -> nl,write("Congrats u won"),nl,write("The word was: "),write(Hword));
	(nl,write("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"),nl,
	write("Player2 must guess the word"),nl,write("Lives: \t"),write(Lives),nl,write("The word:\t"),write(Hword),nl,
	write("Letters you used: \t"),write(Used),nl,write("Make your guess"),read(Guess)),
	(
		
	

	%Case:0 Lives=0,game ends,Loss.
	%	Or found all letter ListHword=[H|T]
		(
		 string_chars(Guess,[G|Uess]),[G|Uess]==[H|T]  -> write("Congrats u won"),nl,write("The word was: "),write(Hword)		
		);
	%Case:1  Attempt to use a used letter(or word), restart game/5
		(
			(member(Guess,Used) -> write("You already used that letter"),nl,write("try again"),nl),
				game(GuessN,Lives,[H|T],ListHword,Used,L)
		);
	%Case:2  Guess a whole word (>1 letter), 
		
		(	%We check if GuessLength>1 .
		   atom_length(Guess,GuessLength),GuessLength>1,	   	
			% Guess \= Word , -1 Life, You lose a life, restart game/5.
			(	(string_chars(Guess,[G|Uess]),	[G|Uess]\==[H|T] ),
				nl,write("Too bad "),write(Guess),write(" is not the word we are looking for"),
				nl,write("Try again ."),
					%restart games/5
					LivesNew is Lives -1, game(GuessN,LivesNew,[H|T],ListHword,Used,L)
			)
		);
	%Case:3  Lives>0,Guess=1l,Guess not used,
	%	 Guess is good,restart game/5.
		member(Guess,[H|T]) ->
		(		
				nl,write("You choice : "),write(Guess),write(" matches"),nl,
				write("The secret word now becomes  :"),nl,
			%MIXANISMOS gia na emfanizei kai na allazei thn kryfh leksi
				letterFound([H|T],Guess,[H|ListHword],NLHword),atomic_list_concat(NLHword,' ',HwordN),
				write("\t\t"),write(NLHwordN),write("\tLives left: "),write(Lives),nl,
				write("The words u already picked: \t"),write(Used),nl,
				game(GuessN,Lives,[H|T],NLHword,[Guess|Used],L)	
		);
		
	%Case:4  Lives>0,Guess=1l,Guess not used,
	%	 Guess is bad,restart game/5.
		(	LivesNew is Lives-1,
		 	
			write("Letter "),write(Guess),write(" does not match."),nl,
			game(GuessN,LivesNew,[H|T],ListHword,[Guess|Used],L)
		)
	)).

letterFound([K],Guess,Found,[K]).
%letterFound([Guess|T],Guess,[Guess|Hword]).
letterFound([H|T],Guess,Found,[H|NLHword]):-
	(Guess==H ; member(H,Found) ) ->letterFound(T,Guess,Found,NLHword).
letterFound([H|T],Guess,Found,['\x5F'|NLHword]):-
	(Guess\==H ) ->letterFound(T,Guess,Found,NLHword).

last([H|T],K):- last(T,K).
last([H],H).
	
	
letterFoundFirstLast([K],F,L,[],[K]).
letterFoundFirstLast([H|T],First,Last,[],[H|ListHword]):-
	(H==First ; H==Last) -> letterFoundFirstLast(T,First,Last,[],ListHword).
letterFoundFirstLast([H|T],First,Last,[],['\x5F'|ListHword]):-
	letterFoundFirstLast(T,First,Last,[],ListHword).
		
