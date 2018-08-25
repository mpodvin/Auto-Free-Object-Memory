(*
  Automatic local free object/memory without memory consumption penalty
  Copyright (c) 2018 Michel Podvin

  MIT License
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  Based On :
  - Andreas Hausladen's blog post
    (http://andy.jgknet.de/blog/2017/10/technical-the-same-but-different-generated-code/)
  - Sergey Antonov(aka oxffff)'s code
  - Deltics's idea (http://www.deltics.co.nz/blog/posts/391)
*)
unit MK.AutoFree;
{$M-,O+}
interface

type
  TAutoFreeTmpRec = packed record // don't use it!
  public
    VMT:Pointer;
    Unknown:IInterface;
    //RefCount:Integer; //not necessary here!
    Ptr:Pointer;
  end;

function AutoFree(AObject:TObject):TAutoFreeTmpRec;overload;
function AutoFree(var AObject; ANewObject:TObject):TAutoFreeTmpRec;overload;

function AutoFreeMem(AMemPtr:Pointer):TAutoFreeTmpRec;

function TransferPtr(var Obj):Pointer;inline;

implementation

type
  PAutoFreeRec = ^TAutoFreeTmpRec;
  PObject = ^TObject;

function TransferPtr(var Obj):Pointer;
begin
  Result := Pointer(Obj);
  TObject(Obj) := nil;
end;

function _AddRef(Self:PAutoFreeRec): Integer;stdcall;//for fun
begin
  Result := 0;
end;

function _ReleaseObject(Self:PAutoFreeRec): Integer;stdcall;
begin
  TObject(Self^.Ptr).Free;
  Result := 0;
end;

function _ReleaseObjectRef(Self:PAutoFreeRec): Integer;stdcall;
begin
  PObject(Self^.Ptr)^.Free;
  Result := 0;
end;

function _ReleaseMemory(Self:PAutoFreeRec): Integer;stdcall;
begin
  FreeMem(Self^.Ptr);
  Result := 0;
end;

const
  _OBJECT_VMT:array[0..2] of Pointer = (nil, @_AddRef, @_ReleaseObject);
  _OBJECTREF_VMT:array[0..2] of Pointer = (nil, @_AddRef, @_ReleaseObjectRef);
  _MEMORY_VMT:array[0..2] of Pointer = (nil, @_AddRef, @_ReleaseMemory);

function AutoFree(AObject:TObject):TAutoFreeTmpRec;
begin
  with Result do
  begin
    if Assigned(Pointer(Unknown)) then Unknown._Release;
    VMT              := @_OBJECT_VMT;
    Pointer(Unknown) := @Result; //@VMT
    Ptr              := AObject;
  end;
end;

function AutoFree(var AObject; ANewObject:TObject):TAutoFreeTmpRec;
begin
  with Result do
  begin
    if Assigned(Pointer(Unknown)) then Unknown._Release;
    VMT              := @_OBJECTREF_VMT;
    Pointer(Unknown) := @Result; //@VMT
    Ptr              := @AObject;
  end;
  TObject(AObject) := ANewObject;
end;

function AutoFreeMem(AMemPtr:Pointer):TAutoFreeTmpRec;
begin
  with Result do
  begin
    if Assigned(Pointer(Unknown)) then Unknown._Release;
    VMT              := @_MEMORY_VMT;
    Pointer(Unknown) := @Result; //@VMT
    Ptr              := AMemPtr;
  end;
end;

end.
