.model small
.stack 100h ;1KB by default
.data

        ;Program Title
        programTitle db '                       |FSEC-SS CASH REGISTER SYSTEM|$' 

        ;Event Titles
        event1Title  db      '|Python Scripting(Workshop)|$'
        event2Title  db      '|Web Exploitation(Workshop)|$'
        event3Title  db      '|Binary Exploitation(Workshop)|$'
        event4Title  db      '|Boot2Root(Workshop)|$'
        event5Title  db      '|APU x BAT CTF 2022(Competition)|$'
        event6Title  db      '|Battle of Hackers 2022(Competition)|$'

        ;Event Prices
        event1Price     db      10
        event2Price     db      10
        event3Price     db      12
        event4Price     db      12
        event5Price     db      30
        event6Price     db      30

        ;Number of slots per event
        event1Slots     db      40
        event2Slots     db      40
        event3Slots     db      40
        event4Slots     db      40
        event5Slots     db      60
        event6Slots     db      60

        ;Menu Options
        menuChoices     db      '   Events                                Price      Available Slots$'
        menuChoice1     db      '1. Python Scripting       (Workshop)     RM 10            $'
        menuChoice2     db      '2. Web Exploitation       (Workshop)     RM 10            $'
        menuChoice3     db      '3. Binary Exploitation    (Workshop)     RM 12            $'
        menuChoice4     db      '4. Boot2Root              (Workshop)     RM 12            $'
        menuChoice5     db      '5. APU x BAT CTF 2022     (Competition)  RM 30            $'
        menuChoice6     db      '6. Battle of Hackers 2022 (Competition)  RM 30            $'
        menuChoice7     db      '7. Checkout $'
        menuChoice8     db      '8. Exit $ '

        CRLF            db      13 ,10,'$'
        userLine        db      '-------------------------------------------------$'
        nameInputMsg    db      'User Name      : $'
        nameInput       db      25,0,25 dup('$') 

        menuInputPrompt db      'Please enter a number based on the options above: $'

        dscPercentMsg   db      '50% Discount for FSEC-SS Members $'
        memberPromptMsg db      'Are you a club member? (Y/N): $'
        dscInclusionMsg db      'Discount has been applied...$'

        totalPrice      db      0       ; total price of all slots during checkout
        discountedPrice db      0       ; disocunted price of all the items during checkout 

        totalPriceMsg  db      "Total Price            : RM $"  ;total price to display on screen
        dscPriceMsg    db      "Price After Discount   : RM $"  ;discounted price to display

        addToCartMsg    db      "Item has been added to cart! $" ;msg showing item added to cart
        cartEmptyMsg    db      "Cart is empty! Please add something first to checkout.$"
        checkoutMsg     db      "Checkout Successful!$"

        slotsFullMsg    db      "All slots taken. Please select another event!$"
        invalidKeyPress db      "Error! Invalid option selected.$"
        tryAgainMsg     db      "Press any key to try again...$" ;try again message
        continueMsg     db      "Press any key to continue...$" ;to proceed
        returnToMenuMsg db      "Press any key to return to main menu...$" ;return to menu

        exitMsg         db      "Program will now exit...$"

.code


DispMsg Macro msg ;Call Data Variables
        mov ah, 09h
        lea dx, msg
        int 21h
EndM

clearScreen Proc
        mov ah, 0
        mov al, 3
        int 10h
        ret
clearScreen Endp


;Displays Menu Contents
DisplayMenu Proc 

        DispMsg CRLF
        DispMsg menuChoice1
        mov al, event1Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice2
        mov al, event2Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice3
        mov al, event3Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice4
        mov al, event4Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice5
        mov al, event5Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice6
        mov al, event6Slots
        call Display2Digit
        DispMsg CRLF
        DispMsg menuChoice7
        DispMsg CRLF
        DispMsg menuChoice8
        DispMsg CRLF
        DispMsg CRLF
        ret
DisplayMenu Endp

;Displays prompt to select menu option
menuSelectionPrompt Proc

        mov ah, 09h
        lea dx, menuInputPrompt
        int 21h
        ret

MenuSelectionPrompt Endp

;Used when trying to display two characters on the screen
Display2Digit Proc
        aam
        add ax, 3030h ;00
        mov dh, al 
        mov dl, ah ;ah is the remainder -> moved into dl

        mov ah, 2  ;Display digit/character
        int 21h

        mov dl, dh ;Moving original contents of al to dh and now into dl
                   ;Basically adding dh value to remainder value
        mov ah,2
        int 21h
        ret
Display2Digit Endp


EventSlotsFull Proc
        DispMsg CRLF
        DispMsg CRLF
        DispMsg slotsFullMsg
        DispMsg CRLF
        DispMsg CRLF
        DispMsg returnToMenuMsg

        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp MainMenu
EventSlotsFull Endp


;Continues if menu option 1 is selected
MenuOption1 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle ;Displays the program title on the screen
        DispMsg CRLF
        DispMsg CRLF
        DispMsg event1Title ;Displays the title of the first event on the screen
        mov al, event1Slots ;
        cmp al, 00     ;checks if available event slots == 0
        jne Available1
        call EventSlotsFull

Available1:
        sub al, 1       ;subtract 1 available slot from the event1
        mov event1Slots, al  ;stiores data back into event1Slots variable
        mov al, event1Price  ;moves price into accumulator register to add price
        mov dl, 31h
        call AddToCart ;Calls AddToCart function to add item to cart and update price
        jmp MainMenu  ;Jumps back to the main menu
        
MenuOption1 Endp

MenuOption2 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF 
        DispMsg CRLF
        DispMsg event2Title
        mov al, event2Slots
        cmp al, 00     ;checks if available slots == 0
        jne Available2
        call EventSlotsFull

Available2:
        sub al, 1       ;subtract 1 available slot from the event3
        mov event2Slots, al
        mov al, event2Price
        mov dl, 32h
        call AddToCart
        jmp MainMenu
MenuOption2 Endp

MenuOption3 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        DispMsg event3Title
        mov al, event3Slots
        cmp al, 00     ;checks if available slots == 0
        jne Available3
        call EventSlotsFull

Available3:
        sub al, 1       ;subtract 1 available slot from the event3
        mov event3Slots, al
        mov al, event3Price
        mov dl, 33h
        call AddToCart
        jmp MainMenu
MenuOption3 Endp

MenuOption4 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        DispMsg event4Title
        mov al, event4Slots
        cmp al, 00     ;checks if available slots == 0
        jne Available4
        call EventSlotsFull

Available4:
        sub al, 1       ;subtract 1 available slot from the event4
        mov event4Slots, al
        mov al, event4Price
        mov dl, 34h
        call AddToCart
        jmp MainMenu
MenuOption4 Endp

MenuOption5 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        DispMsg event5Title
        mov al, event5Slots
        cmp al, 00     ;checks if available slots == 0
        jne Available5
        call EventSlotsFull

Available5:
        sub al, 1       ;subtract 1 available slot from the event5
        mov event5Slots, al
        mov al, event5Price
        mov dl, 35h
        call AddToCart
        jmp MainMenu
MenuOption5 Endp


MenuOption6 Proc
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        DispMsg event6Title
        mov al, event6Slots
        cmp al, 00     ;checks if available slots == 0
        jne Available6
        call EventSlotsFull

Available6:
        sub al, 1       ;subtract 1 available slot from the event6
        mov event6Slots, al
        mov al, event6Price
        mov dl, 36h
        call AddToCart
        jmp MainMenu
MenuOption6 Endp


MenuOption8 Proc ;Used to exit the program
        DispMsg CRLF  
        DispMsg CRLF
        DispMsg exitMsg ;Display exit message to the user
        DispMsg CRLF
        DispMsg CRLF
        mov ah, 4ch
        int 21h  ;Close the DOS
        ret
MenuOption8 Endp


AddToCart Proc
        add al, totalPrice ;sum total cost
        mov totalPrice, al
        DispMsg CRLF
        DispMsg addToCartMsg ;Display add to cart message to the user
        DispMsg CRLF
        DispMsg CRLF
        DispMsg continueMsg ;Message for user to return to main menu

        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp MainMenu
AddToCart Endp


UserNameInput Proc
        
        DispMsg CRLF
        DispMsg nameInputMsg ; Prompt to enter participant name
        mov ah, 0AH
        mov dx, offset nameInput ;Accept name input
        int 21h
        jmp ContCheckout
UserNameInput Endp

InvalidMemberInput Proc
        DispMsg CRLF
        DispMsg invalidKeyPress ;Display invalid key press message
        DispMsg CRLF
        DispMsg tryAgainMsg ;Tells user to try again

        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp BeginCheckout
InvalidMemberInput Endp


Checkout Proc

BeginCheckout:
        call clearScreen
        DispMsg CRLF
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        call UserNameInput
        
ContCheckout:
     
        DispMsg CRLF
        DispMsg CRLF
        DispMsg dscPercentMsg
        DispMsg CRLF
        DispMsg memberPromptMsg

        ;Check if club member or not
        mov ah, 01h
        int 21h

        mov dl, al; move user input to dl
        mov ah, 01h
        int 21h

        cmp dl, 89 ;if input is Y
        je ClubMember
        
        cmp dl, 121 ; if input is y
        je ClubMember

        cmp dl, 78 ;if input is N
        je NotClubMember

        cmp dl, 110 ;if input is n  
        je NotClubMember

        call InvalidMemberInput

ClubMember: 
        ;Club Member Checkout Process
        DispMsg CRLF
        DispMsg CRLF
        DispMsg totalPriceMsg 
        mov al, totalPrice
        call Display2Digit
        DispMsg CRLF

        ;Divide the total price by 2 to get discount amount
        mov ah, 00
        mov al, totalPrice
        mov bl, 2
        div bl
        mov discountedPrice, al
        DispMsg dscPriceMsg ;Display discounted price to the user
        mov al, discountedPrice ;Value of the discounted price
        call Display2Digit ;Used to display double digit value
        DispMsg CRLF
        DispMsg CRLF
        DispMsg checkoutMsg ;Display check out complete message to the user
        DispMsg CRLF
        DispMsg CRLF
        DispMsg returnToMenuMsg ;Display return message to go back to main menu
        
        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp CompleteCheckout


NotClubMember:
        ;Non-Club Member Checkout Process
        DispMsg CRLF
        DispMsg CRLF
        DispMsg totalPriceMsg ;Display total price message to user
        mov al, totalPrice ;Value of the total price
        call Display2Digit ;Used to display double digit value
        DispMsg CRLF
        DispMsg CRLF
        DispMsg checkoutMsg
        DispMsg CRLF
        DispMsg CRLF
        DispMsg returnToMenuMsg

        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp CompleteCheckout

CompleteCheckout:
        mov discountedPrice, 0
        mov totalPrice, 0
        jmp MainMenu

Checkout Endp


Main Proc
        ;Allow access to variables in the data section
        mov ax, @data
        mov dx, ax    
        mov ds, ax

MainMenu:
        call clearScreen
        DispMsg CRLF
        DispMsg programTitle
        DispMsg CRLF
        DispMsg CRLF
        DispMsg menuChoices
        DispMsg CRLF

        ;To display '-' 80 times
        mov cx, 80
        mov ah, 02h 

        ShowLine1:
                mov dl, 45 ; - symbol in ASCII 
                int 21h
                loop ShowLine1

        call DisplayMenu ;Display menu content on the screen
        call menuSelectionPrompt ;Prompt user to select a menu option
        
        ;Accept User input for menu option
        mov ah, 01h     
        mov dl, al
        int 21h
        mov dl, al

Choice1:
        ;Process when option 1 is selected
        cmp dl, 31h
        jne Choice2      ;jump to choice 2 if not equal to 1
        call MenuOption1 ;Call menu option 1 procedure
        
        
Choice2:
        cmp dl, 32h
        jne Choice3
        call MenuOption2


Choice3:
        cmp dl, 33h
        jne Choice4
        call MenuOption3

Choice4:
        cmp dl, 34h
        jne Choice5
        call MenuOption4

Choice5:
        cmp dl, 35h
        jne Choice6
        call MenuOption5

Choice6:
        cmp dl, 36h
        jne Choice7
        call MenuOption6

Choice7:
        cmp dl, 37h
        jne Exit

        ;Validate Checkout -> Check if there's any items in the cart
        mov al, totalPrice
        cmp al, 0
        jne CheckoutPoint ;Jump to the checkpoitn point to call the checkout process
        DispMsg CRLF
        DispMsg CRLF
        DispMsg cartEmptyMsg ;Notifies the user that the cart is empty
        DispMsg CRLF
        DispMsg tryAgainMsg ;Tells the user to try again
        DispMsg CRLF
        DispMsg CRLF
        
        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp MainMenu        
        
CheckoutPoint:
        call Checkout ;Calls checkout procedure to begin checkout process

Exit:
        ;Exits the program when option 8 is selected
        cmp dl, 38h
        jne Error
        call MenuOption8

Error:
        DispMsg CRLF
        DispMsg CRLF
        DispMsg invalidKeyPress ;Tells the user that an invalid key was pressed
        DispMsg CRLF
        DispMsg tryAgainMsg ;Tell the user to try again 
        
        ;Allow user to press any key to continue
        mov ah, 01h
        int 21h
        jmp MainMenu   

Main Endp
End Main