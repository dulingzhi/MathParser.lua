local c={}local l={}local o={}local function a(e)local n=l[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
l[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local r=string.char
local t=string.match
local a=string.gmatch
local i=table.insert
local c=string.utf8len or string.len
local l=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local o={}for n=1,c(e)do
local e=l(e,n,n)i(o,e)end
return o
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=r(n)if t(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,l in ipairs(e)do
local e=o
for n in a(l,".")do
e[n]=e[n]or{}e=e[n]end
e.value=l
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local T=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(n,o,l,e)e[n]=o end,}}local f={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(n,e,o,c)local r=n
local t=e or{}local l=o or a
local s=c or{}local d,u,i,c,o
function d(e)local n=e.Value
local l=l.Unary[n]assert(l,"invalid operator: "..tostring(n))local n=o(e.Operand)return l(n,e)end
function u(e)local n=e.Value
local r=e.Left
local a=e.Right
local n=l.Binary[n]assert(n,"invalid operator")local l=o(r)local o=o(a)return n(l,o,e,t)end
function i(e)local n=not(not e.Operand)if n then
return d(e)end
return u(e)end
function c(n)local e=n.FunctionName
local l=n.Arguments
local n=s[e]or f[e]assert(n,"invalid function call: "..tostring(e))local e={}for l,n in ipairs(l)do
local n=o(n)T(e,n)end
return n(p(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=t[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return i(n)elseif e=="FunctionCall"then
return c(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function i(o,c,n,e)r=o
t=c or{}l=n or a
s=e or f
end
local function e()assert(r,"No expression to evaluate")return o(r)end
return{resetToInitialState=i,evaluate=e}end
return h end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local h=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local l=table.insert
local P=string.rep
local v=n.createConstantToken
local x=n.createVariableToken
local g=n.createParenthesesToken
local k=n.createOperatorToken
local E=n.createCommaToken
local V=n.createStrToken
local f="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local y="Expected a number after the decimal point"local w="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local U="No charStream given"local p={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local T=h(p)local S=e("%s")local a=e("%d")local L=e("[a-zA-Z_%.]")local m=e("[%da-fA-F]")local _=e("[+-]")local F=e("[eE]")local N=e("[xX]")local C=e("[a-zA-Z0-9_%.]")local A=e("[()]")local function R(n,o,u)local s={}local i={}local t,r,e
if n then
n=n
t=b(n)r=t[u or 1]e=u or 1
s[n]=t
end
local n=(o and h(o))or T
local Y=o or p
local u=n
local function n()return t[e+1]or"\0"end
local function o(n)local o=e+(n or 1)local n=t[o]or"\0"e=o
r=n
return n
end
local function d(n,o)local e=e+(o or 0)local e=P(" ",e-1).."^"local e="\n"..c(t).."\n"..e.."\n"..n
return e
end
local function P()local e=i
if#e>0 then
local e=c(e,"\n"..f)error("Lexer errors:".."\n"..f..e.."\n"..f)end
end
local function H(e)local e=(e or r)return a[e]or(e=="."and a[n()])end
local function R(e)l(e,o())local t=m[n()]if not t then
local e=d(O,1)l(i,e)end
repeat
l(e,o())t=m[n()]until not t
return e
end
local function O(e)l(e,o())local t=a[n()]if not t then
local e=d(y,1)l(i,e)end
repeat
l(e,o())t=a[n()]until not t
return e
end
local function f(e)l(e,o())if _[n()]then
l(e,o())end
local t=a[n()]if not t then
local e=d(w,1)l(i,e)end
repeat
l(e,o())t=a[n()]until not t
return e
end
local function m()local e={r}local t=false
local t=false
local t=false
if r=='0'and N[n()]then
return c(R(e))end
while a[n()]do
l(e,o())end
if n()=="."then
e=O(e)end
local n=n()if F[n]then
e=f(e)end
return c(e)end
local function f()local r={r}local a=u
local t=t
local e=e
local n=1
while true do
local e=t[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
l(r,e)end
if n>0 then
o(n-1)end
return c(r)end
local function d()local l,e={},0
local t
repeat
e=e+1
l[e]=r
local e=n()until not(C[e]and o())return c(l)end
local function c()if H(r)then
local n=m()return v(n,e)end
local n=f()return V(n,e)end
local function a()local n=u
local r=t
local t=e
local e
local l=0
while true do
local o=r[t+l]n=n[o]if not n then break end
e=n.value
l=l+1
end
if not e then return end
o(#e-1)return e
end
local function l()local n=r
if S[n]then
return
elseif A[n]then
return g(n,e)elseif L[n]then
return x(d(),e)elseif n==","then
return E(e)else
local n=a()if n then
return k(n,e)end
return c()end
end
local function a()local n,e={},0
local t=r
while t~="\0"do
local l=l()if l then
e=e+1
n[e]=l
end
t=o()end
return n
end
local function l(n,o)if n then
n=n
t=s[n]or b(n)r=t[1]e=1
s[n]=t
end
u=(o and h(o))or T
Y=o or p
end
local function e()assert(t,U)i={}local e=a()P()return e
end
return{resetToInitialState=l,run=e}end
return R end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local s=n.stringToTable
local p=table.insert
local n=table.concat
local d=math.max
local f=math.min
local Y=string.rep
local F=e.createUnaryOperatorNode
local R=e.createOperatorNode
local L=e.createFunctionCallNode
local a=20
local S="No tokens given"local O="No tokens to parse"local k="Expected EOF, got '%s'"local g="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local i="Expected expression, got EOF"local v="Expected ')', got EOF"local b="Expected ',' or ')', got '%s'"local u="<No charStream, error message: %s>"local h={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function V(r,c,o,t,n)local l,e
if r then
l=o or 1
e=r[l]end
local o=c or h
local c=t
local m=n
local function T(e)return r[l+(e or 1)]end
local function n(n)local o=l+(n or 1)local n=r[o]l=o
e=n
return n
end
local function E(n)local e=n or e
if not o.Binary then return end
return e and e.TYPE=="Operator"and o.Binary[e.Value]end
local function V(n)local e=n or e
if not o.Unary then return end
return e and e.TYPE=="Operator"and o.Unary[e.Value]end
local function y(n)local e=n or e
if not o.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and o.RightAssociativeBinaryOperators[e.Value]end
local function x()if m[e.Value]~=nil then
return true
end
local n=T()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function P(e)return e and o.Binary[e.Value]end
local function t(o,...)if not c then
return u:format(o)end
local n=s(c)local l=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=d(1,e-a),f(e+a,#n)do
p(o,n[e])end
local n=table.concat(o)local e=Y(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..l
end
local s,d,u,f,a
function s()local l=e.Value
n(2)local o={}while true do
local l=a()p(o,l)if not e then
local e=T(-1)if e and e.TYPE=="Comma"then
error(t(i))end
break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(t(b,e.Value))end
end
n()return L(l,o)end
function d(r)local o=u()while E(e)do
local l=P(e)if l<=r and not y(e)then
break
end
local r=e
if not n()then
error(t(i))end
local e=d(l)o=R(r.Value,o,e)end
return o
end
function u()if not V(e)then
return f()end
local o=e.Value
if not n()then
error(t(i))end
local e=u()return F(o,e)end
function f()local o=e
if not o then return end
local r=o.Value
local l=o.TYPE
if l=="Parentheses"and r=="("then
n()local o=a()if not e or e.Value~=")"then
error(t(v))end
n()return o
elseif l=="Variable"then
if x()then
return s()end
n()return o
elseif l=="Constant"or l=="String"then
n()return o
end
error(t(g,r))end
function a()local e=d(0)return e
end
local function i(n,u,a,i,t)assert(n,S)r=n
l=a or 1
e=n[l]o=u or h
c=i
m=t
end
local function o(n)assert(r,O)local o=a()if e and not n then
error(t(k,e.Value))end
return o
end
return{resetToInitialState=i,parse=o}end
return V
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,n,e)return{TYPE="Operator",Value=o,Left=n,Right=e}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local u=a("Evaluator/Evaluator")local d=a("Lexer/Lexer")local i=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e,self.functions)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e)if self.cachedResults[e]then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local n=self.Evaluator:evaluate()self.cachedResults[e]=n
return n
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(e,n)self.variables=self.variables or{}self.variables[e]=n
self.cachedResults={}end
function e:addVariables(e)for n,e in pairs(e)do
self:addVariable(n,e)end
self.cachedResults={}end
function e:addFunction(n,e)self.functions=self.functions or{}self.functions[n]=e
self.cachedResults={}end
function e:addFunctions(e)for e,n in pairs(e)do
self:addFunction(e,n)end
self.cachedResults={}end
function e:setOperatorPrecedenceLevels(e)self.operatorPrecedenceLevels=e
self.cachedASTs={}end
function e:setVariables(e)self.variables=e
self.cachedResults={}end
function e:setOperatorFunctions(e)self.operatorFunctions=e
self.cachedResults={}end
function e:setOperators(e)self.operators=e
self.cachedTokens={}end
function e:setFunctions(e)self.functions=e
self.cachedResults={}end
function e:resetCaches()self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
function e:resetToInitialState(t,l,o,e,n)self.operatorPrecedenceLevels=t
self.variables=l
self.operatorFunctions=o
self.operators=e
self.functions=n
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local c={}function c:new(l,o,a,r,t)local n={}for e,l in pairs(e)do
n[e]=l
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=l
n.variables=o
n.operatorFunctions=a
n.operators=r
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=d(nil,r)n.Parser=i(nil,l)n.Evaluator=u(nil,o,a,t)return n
end
return c end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
