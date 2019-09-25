--Balance Transfer Logic

Create Table BankABC
(
CustomerID INT,
CustomerPhone Int Primary Key,
AccountBalance Int
)


Create Table BankXYZ
(
CustomerID int,
CustomerPhone Int Primary Key,
AccountBalance Int
)

INSERT INTO BankABC VALUES(1,1234,1500)
INSERT INTO BankXYZ Values(1,5678,0)

SELECT * FROM BankABC
SELECT * FROM BankXYZ


-----Stored Procedure Logic 
Create Proc sp_BalanceTransfer
@FromPhone int,
@ToPhone int,
@AmmountToTransfer int
AS
Begin
    Declare @AvailableBalanceFromPh Int
	SELECT @AvailableBalanceFromPh=AccountBalance 
	                              From BankABC Where CustomerPhone=@FromPhone
	IF(@AvailableBalanceFromPh<@AmmountToTransfer)
	   Begin
		Raiserror('Not Enough Balance',16,1)
	   End
	Else
	   Begin
	      Begin Tran
		  --Update Account Balance In BankABC
		  Update BankABC Set AccountBalance=(AccountBalance-@AmmountToTransfer)
		  Where CustomerPhone=@FromPhone

		  --Update Account Balance In BankXYZ
		  Update BankXYZ Set AccountBalance=(AccountBalance+@AmmountToTransfer)
		  Where CustomerPhone=@ToPhone
		  Commit Tran
	   End
End


