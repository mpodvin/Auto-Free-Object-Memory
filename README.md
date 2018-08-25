# Auto Free Object/Memory
Automatic local free object/memory without memory consumption penalty

```pascal
var
  SList1,SList2,SList3:TStringList;
begin
  SList1 := nil;
  SList2 := nil;
  SList3 := nil;
  try
    SList1 := TStringList.Create;
    SList2 := TStringList.Create;
    SList3 := TStringList.Create;
    //use it!
    //...
  finally
    SList1.Free;
    SList2.Free;
    SList3.Free;
  end;
end;
```

Replaced by :

```pascal
var
  SList1,SList2,SList3:TStringList;
begin
  AutoFree(SList1, TStringList.Create);
  AutoFree(SList2, TStringList.Create);
  AutoFree(SList3, TStringList.Create);
  //use it!
  //...
end;
```
