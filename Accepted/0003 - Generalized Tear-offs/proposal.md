#Generalized Tear-offs

## Contact information

1. **Gilad Bracha.** 

2. **gbracha@google.com.** 

3. **https://github.com/gbracha/generalizedTearOffs** 



##Summary 

The Dart language supports closurization of methods (aka tear-offs). Closurization is currently specified in section 16.18.1 of the Dart standard. However, closurization cannot be applied to constructors, operators, getters or setters. The reason is that closurization is represented syntactically via an overloading of the dot operator.

This proposal introduces a separate syntax for closurization. The syntax applies uniformly to all member functions. One may write:

`new T#`  as an approximation of  `(a1, …, an) => new T(a1, …, an)`

`new T#namedConstructor` as an approximation of `(a1, …, an) => new T.namedConstructor(a1, …, an)`

`C#staticMethod` as an approximation of  `(a1, …, an) =>  C.staticMethod(a1, …, an)`

`C#staticGetter` as an approximation of `() => C.staticGetter`

`C#staticSetter=` as an approximation of `(a) => C.staticSetter = a`

`o#instanceMethod` as an approximation of  `(a1, …, an) =>  o.instanceMethod(a1, …, an)`

`o#instanceGetter` as an approximation of `() => o.instanceGetter`

`o#instanceSetter=` as an approximation of `(a) => o.instanceSetter = a`

`o#binop` as an approximation of `(a) => o binop a` (and similarly for `[]=` and `~`).

`super#instanceMethod` as an approximation of  `(a1, …, an) =>  super.instanceMethod(a1, …, an)`

`super#instanceGetter` as an approximation of `() => super.instanceGetter`

`super#instanceSetter=` as an approximation of `(a) => super.instanceSetter = a`



The translations above are only approximations, because closurization has special rules wrt typechecking and closure equality.  The static type rules give more precise return types than for ordinary closures. The special casing of equality allows similar closures created separately via closurization to be considered equal. The rules are in essence the same as those given in the Dart spec for the current form of closurization.

In all of the above cases, `T` may be taken to represent a parameterized type or an identifier. 

##Motivation 

Dart users working with projects as varied as Angular.Dart, Dart serialization and the core libs have brought up these issues: see bugs 
https://code.google.com/p/dart/issues/detail?id=5879
https://code.google.com/p/dart/issues/detail?id=10659
https://code.google.com/p/dart/issues/detail?id=13389

for examples.

###Pros 

Eliminates the limitations of the existing tear-off syntax: one can tear off constructors, operators, getters and setters. Such limitations are a language design smell that should be eliminated.

Possibly improves tear-off performance slightly. In principle, a given construct should do one thing. The tear-off syntax violates that principle. As a result, when confronted with an expression `e.m`, it is not statically know whether to invoke a getter method or closurize. This adds overhead in time and space that cannot always be optimized away.  While we cannot improve the performance of the current misdesign, the new feature doesn’t have this problem.



###Cons 

Any additional feature comes at a cost. More syntax to learn (and this syntax is not familiar), more features to be implemented (and the opportunity cost of not focusing on something else), added size and complexity in the implementation.  That much can be said of any language feature. 

Certain things can be done in more than one way, which is in general an anti-pattern in language design. Specifically, one can tear-off a method `m` in two ways: `o.m` or `o#m`. 

Both of the above imply one more issue to debate in style guides and/or code reviews. Should one use the old syntax where it applies (making code more familiar) or the new one (more efficient and less ambiguous)? Which is more readable? The old one that is familiar, or the new one that is unambiguous? The new syntax is perhaps more robust in the face of code changes (you can change a getter to a method or vice versa and the meaning won’t change). 

##Examples   


`new List#`

`new DateTime#utc`

`new List<String>#` 

`new Map<String,int>#`

`new Map<Symbol,Type>#from`


It is possible to do some strange looking things like

`new List<String>##call  // same as (new List<String>#)#call`

which is a closure that when invoked, calls a closure that allocates a new list of string. I doubt that we’ll see much of these, since it is rather pointless.

The proposal does not allow for the use of a tear-off as a constant closure. 


## Proposal

See above.


## Deliverables


### Language specification changes

Commentary on the specification is given in *italics*. Rationale is in **bold**.

		 	 	 		
###  9.3 Type of a Function 
					
If a function does not declare a return type explicitly, its return type is dynamic (19.6), unless it is a constructor function, in which case its return type is the immediately enclosing class. 
	Rest  of 9.3 is unchanged; the above addition is true in any case and it is good to have it stated explicitly; it didn’t really matter until now, but the definitions below make use of the type of a constructor function. 			
			
		
		
				
					
## 16 Expressions	 
			
```
expression:
      assignableExpression assignmentOperator expression
    | conditionalExpression cascadeSection*
    | throwExpression
    ;


expressionWithoutCascade:
      assignableExpression assignmentOperator expressionWithoutCascade
    | conditionalExpression
    | throwExpressionWithoutCascade
   ;


expressionList:
      expression (',' expression)*
    ;


primary:
      thisExpression
    | super (assignableSelector | ‘#’ (( identifier ‘=’?) | operator)
    | functionExpression
    | literal
    | identifier ( ‘#’  (( identifier ‘=’?) | operator) )?
    | newExpression
    | new type# (‘.’ identifier)?	
    | const type# (‘.’ identifier)?	   	 	 	 		
    | constObjectExpression
    | '(' expression ')
    ;
```

An expression *e* may always be enclosed in parentheses, but this never has any semantic effect on *e*.

Sadly, it may have an effect on the surrounding expression. Given a class *C* with static method `m => 42`, `C.m()` returns `42`, but `(C).m()` produces a `NoSuchMethodError`.  This anomaly can be corrected by ensuring that every instance of `Type` has instance members corresponding to its static members. This issue may be addressed in future versions of Dart.

				
					
### 16.18 Property Extraction 
					
Property extraction allows for a member or constructor to be accessed as a property rather than a function. A property extraction can be either:

* A _closurization_ which converts a method or constructor into a closure. Or
* A _getter invocation_ which returns the result of invoking a getter method.

Property extraction takes several syntactic forms: _e.m_ (16.18.1), __super__*.m* (16.18.2),  _e#m_ (16.18.3), **new** *T#m* (16.18.4),  **new** *T#* (16.18.5)     and **super** *#m* (16.18.6), where *e* is an expression, *m* is an identifier optionally followed by an equal sign and *T* is a type.

#### 16.18.1 Getter Access and Method Extraction 

Evaluation of a property extraction *i* of the form *e.m* proceeds as follows:
					
First, the expression *e* is evaluated to an object *o*. Let *f* be the result of looking up (16.15.1) method (10.1) *m* in *o* with respect to the current library *L*. If *o* is an instance of `Type` but *e* is not a constant type literal, then if *f* is a method that forwards (9.1) to a static method, method lookup fails. If method lookup succeeds then *i* evaluates to the closurization of method *f* on object *o* (16.18.7).

*Note that *f* is never an abstract method, because method lookup skips abstract methods. Hence, if *m* refers to an abstract method, we will continue to the next step. However, since methods and getters never override each other, getter lookup will necessarily fail as well, and `noSuchMethod()` will ultimately be invoked. The regrettable implication is that the error will refer to a missing getter rather than an attempt to closurize an abstract method.*

	
Otherwise, *i* is a getter invocation. Let *f* be the result of looking up (16.15.2) getter (10.2) *m* in *o* with respect to *L*. If *o* is an instance of `Type` but *e* is not a constant type literal, then if *f* is a getter that forwards to a static getter, getter lookup fails. Otherwise, the body of *f* is executed with this bound to *o*. The value of *i* is the result returned by the call to the getter function.

If the getter lookup has failed, then a new instance *im* of the predefined class `Invocation` is created, such that :

* `im.isGetter` evaluates to `true`.

* `im.memberName` evaluates to `’m’`.

* `im.positionalArguments` evaluates to the value of `const []`. 
•
* `im.namedArguments` evaluates to the value of `const {}`.


Then the method `noSuchMethod()` is looked up in *o* and invoked with argument *im*, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of `noSuchMethod()` in class `Object` is invoked on *o* with argument *im′*, where *im′* is an instance of `Invocation` such that :


* `im.isGetter` evaluates to `true`.

* `im.memberName` evaluates to `noSuchMethod`.

* `im.positionalArguments` evaluates to an immutable list whose sole element is *im*.

* `im.namedArguments` evaluates to the value of `const {}`.

and the result of this latter invocation is the result of evaluating *i*.
It is a compile-time error if m is a member of class `Object` and *e* is either a prefix object (18.1) or a constant type literal.

*This precludes `int.toString` but not `(int).toString` because in the latter case, *e* is a parenthesized expression.*

Let *T* be the static type of *e*. It is a static type warning if *T* does not have an accessible instance method or getter named m unless either:

* *T* or a superinterface of *T* is annotated with an annotation denoting a constant identical to the constant proxy defined in `dart:core`. Or

* *T* is `Type`, *e* is a constant type literal and the class corresponding to *e* declares an accessible static method or getter named *m*.


The static type of *i* is:

* The declared return type of `T.m`, if *T* has an accessible instance getter named *m*.

* The declared return type of *m*, if *T* is `Type`, *e* is a constant type literal and the class corresponding to e declares an accessible static getter named *m*.

* The static type of function `T.m` if *T* has an accessible instance method named *m*. 

* The static type of function *m* if *T* is `Type`, *e* is a constant type literal and the class corresponding to *e* declares an accessible static method named *m*.

* The type **dynamic** otherwise.




#### 16.18.2 Super Getter Access and Method Closurization 
	
Evaluation of a property extraction *i* of the form *super.m* proceeds as follows:

Let S be the superclass of the immediately enclosing class. Let *f* be the result of looking up method *m* in *S* with respect to the current library *L*. If method look up succeeds, then *i* evaluates to the closurization of method *f* with respect to superclass *S* (16.18.10).

Otherwise, *i* is a getter invocation.  Let *f* be the result of looking up (16.15.2) getter (10.2) *m* in *S* with respect to *L*.  The body of *f* is executed with this bound to the current value of **this**. The value of *i* is the result returned by the call to the getter function.

If the getter lookup has failed, then a new instance *im* of the predefined class `Invocation` is created, such that :

* `im.isGetter` evaluates to `true`.

* `im.memberName` evaluates to `’m’`.

* `im.positionalArguments` evaluates to the value of `const []`.

* `im.namedArguments` evaluates to the value of `const {}`

Then the method `noSuchMethod()` is looked up in *S* and invoked with argument `im`, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of `noSuchMethod()` in class `Object` is invoked on this with argument *im′*, where *im′* is an instance of Invocation such that :

* `im.isMethod` evaluates to `true`.

* `im.memberName` evaluates to `noSuchMethod`.

* `im.positionalArguments` evaluates to an immutable list whose sole element is *im*.

* `im.namedArguments` evaluates to the value of `const {}`.


and the result of this latter invocation is the result of evaluating *i*.

It is a static type warning if *S* does not have an accessible instance method or getter named *m*. 

The static type of *i* is:

* The declared return type of *S.m*, if *S* has an accessible instance getter named *m*.

* The static type of function *S.m* if *S* has an accessible instance method named *m*.
 
* The type **dynamic** otherwise.


####16.18.3 General Closurization 

Evaluation of a property extraction *i* of the form e#m proceeds as follows:

First, the expression *e* is evaluated to an object *o*. Let *f* be the result of looking up (16.15.1) method (10.1) *m* in *o* with respect to the current library *L*. If *o* is an instance of `Type` but *e* is not a constant type literal, then if *f* is a method that forwards (9.1) to a static method, method lookup fails. If method lookup succeeds then *i* evaluates to the closurization of method *f* on object *o* (16.18.7).

Otherwise, let *f* be the result of looking (16.15.2) up getter (10.2) *m* in *o* with respect to *L*. If *o* is an instance of `Type` but *e* is not a constant type literal, then if *f* is a method that forwards to a static getter, getter lookup fails.  If getter lookup succeeds then *i* evaluates to the closurization of getter *f* on object *o* (16.18.7).

Otherwise, let *f* be the result of looking (16.15.3) up setter (10.2) *m* in *o* with respect to *L*. If *o* is an instance of `Type` but *e* is not a constant type literal, then if *f* is a method that forwards to a static setter, setter lookup fails.  If setter lookup succeeds then *i* evaluates to the closurization of setter *f* on object *o* (16.18.7).

Otherwise, a new instance *im* of the predefined class `Invocation` is created, such that :

* If *m* is a setter name, `im.isSetter` evaluates to `true`; otherwise `im.isMethod` evaluates to `true`.

* `im.memberName` evaluates to `’m’`.

* `im.positionalArguments` evaluates to the value of `const []`. 

* `im.namedArguments` evaluates to the value of `const {}`.

Then the method `noSuchMethod()` is looked up in *o* and invoked with argument *im*, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of `noSuchMethod()` in class `Object` is invoked on *o* with argument `im′`, where `im′` is an instance of `Invocation` such that :

* `im.isMethod` evaluates to `true`.

* `im.memberName` evaluates to `noSuchMethod`.

* `im.positionalArguments` evaluates to an immutable list whose sole element is *im*.

* `im.namedArguments` evaluates to the value of `const {}`.

and the result of this latter invocation is the result of evaluating *i*.

It is a compile-time error if *e* is a prefix object (18.1) and *m* refers to a type or a member of class `Object`.

*This restriction is in line with other limitations on the use of prefixes as objects.  The only permitted uses of *p#m* are closurizing top level methods and getters imported via the prefix *p*. Top level methods are directly available by their qualified names: *p.m*. However, getters and setters are not, and allowing their closurization is the whole point of the *e#m* syntax.*

Let *T* be the static type of *e*. It is a static type warning if *T* does not have an accessible instance method or getter named *m* unless either:

* *T* or a superinterface of *T* is annotated with an annotation denoting a constant identical to the constant proxy defined in `dart:core`. Or

* *T* is `Type`, *e* is a constant type literal and the class corresponding to *e* declares an accessible static method or getter named *m*.


The static type of *i* is:

* The static type of function *T.m* if *T* has an accessible instance member named *m*.

* The static type of function *T.m* if *T* is `Type`, *e* is a constant type literal and the class corresponding to e declares an accessible static member or constructor named *m*.

* The type **dynamic** otherwise.

### 16.18.4 Named Constructor Extraction  

Evaluation of a property extraction *i* of the form **new** *T#m* or **const** *T#m* proceeds as as follows:


If *T* is a malformed type (19.1), a dynamic error occurs. If *T* is a deferred type with prefix *p*, then if *p* has not been successfully loaded, a dynamic error occurs. If *T* does not denote a class, a dynamic error occurs. In checked mode, if *T* or any of its superclasses is malbounded a dynamic error occurs. Otherwise, if the type *T* does not declare an accessible named constructor *f* with name *m*, a `NoSuchMethodError` is thrown. Otherwise, *i* evaluates to the closurization of constructor *f* of type *T* (16.18.8).

*Note that if *T* is malformed or malbounded, a static warning occurs, as always.* 

The static type of *i* is the type of the constructor function, if *T* denotes a class in the surrounding scope with an accessible (6.2) constructor *f* named *m*. Otherwise the static type of *i* is **dynamic**.

### 16.18.5 Anonymous Constructor Extraction 

 Evaluation of a property extraction *i* of the form **new** *T#*  or **const** *T#* proceeds as follows:

If *T* is a malformed type (19.1), a dynamic error occurs. If *T* is a deferred type with prefix *p*, then if *p* has not been successfully loaded, a dynamic error occurs. If *T* does not denote a class, a dynamic error occurs. In checked mode, if *T* or any of its superclasses is malbounded a dynamic error occurs. Otherwise, if the type *T* does not declare an accessible anonymous constructor, `NoSuchMethodError` is thrown. Otherwise, *i* evaluates to the closurization of the anonymous constructor of type *T* (16.18.9).

*Again, note that if *T* is malformed, existing rules ensure that a static warning occurs. This also means that *x#* where *x* is not a type will always give a static warning.*

The static type of *i* is the type of the constructor function *T()*, if *T* denotes a class in the surrounding scope with an anonymous constructor *T()*.  Otherwise the static type of *i* is **dynamic**.


### 16.18.6 General Super Property Extraction 

Evaluation of a property extraction *i* of the form super#m proceeds as follows:

Let *S* be the superclass of the immediately enclosing class. Let *f* be the result of looking up method *m* in *S* with respect to the current library *L*. If method lookup succeeds then *i* evaluates to the closurization of method *m* with respect to superclass *S* (16.18.10).

Otherwise, let *f* be the result of looking (16.15.2) up getter (10.2) *m* in *S* with respect to *L*. If getter lookup succeeds then *i* evaluates to the closurization of getter *m* with respect to superclass *S* (16.18.10).

Otherwise, let *f* be the result of looking (16.15.3) up setter (10.2) *m* in *S* with respect to *L*.  If setter lookup succeeds then *i* evaluates to the closurization of setter *m* with respect to superclass *S*  (16.18.10).

Otherwise, a new instance *im* of the predefined class `Invocation` is created, such that :

* If *m* is a setter name, `im.isSetter` evaluates to `true`; otherwise `im.isMethod` evaluates to `true`.

* `im.memberName` evaluates to `’m’`.

* `im.positionalArguments` evaluates to the value of `const []`. 

* `im.namedArguments` evaluates to the value of `const {}`.

Then the method `noSuchMethod()` is looked up in *S* and invoked with argument *im*, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of `noSuchMethod()` in class `Object` is invoked on **this** with argument `im′`, where `im′` is an instance of `Invocation` such that :

* `im.isMethod` evaluates to `true`.

* `im.memberName` evaluates to `noSuchMethod`.

* `im.positionalArguments` evaluates to an immutable list whose sole element is *im*.

* `im.namedArguments` evaluates to the value of `const {}`.

and the result of this latter invocation is the result of evaluating *i*.

It is a static type warning if *S* does not have an accessible instance member named *m*. 

The static type of *i* is the static type of function *S.m*, if *S* has an accessible instance member named *m*. Otherwise the static type of *i* is **dynamic**.


### 16.18.7 Ordinary Member Closurization 


Let *o* be an object, and let *u* be a fresh final variable bound to *o*:

The *closurization of method f on object o* is defined to be equivalent to:

* `(a){return u m a;}` if *f* is named *m* and *m* is one of 	`<,>,<=,>=,==,-,+, ̃/,/,*,%,|,ˆ,&,<<,>>,[]` (this precludes closurization of unary `-`).

* `(){return ~u;}` if *f* is named `~`.

* `(a, b){return u[a] = b;}` if *f* is named `[]=`.

* `(r1,...,rn,{p1 : d1,...,pk : dk}){return u.m(r1, ..., rn, p1 : p1, ..., pk : pk);  }`cif *f* is named *m* and has required parameters *r1, . . . , rn*, and named parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

* `(r1,...,rn,[p1 = d1,...,pk = dk]){ return u.m(r1, ..., rn, p1, ..., pk);}` if *f* is named *m* and has required parameters *r1, . . . , rn*, and optional positional parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

Except that iff `identical(`*o1*`, `*o2*`)` then *o1#m == o2#m*, *o1.m == o2.m*, *o1#m == o2.m* and  *o1.m == o2#m*.	

The closurization of getter *f* on object *o* is defined to be equivalent to `(){return u.m; }` if *f* is named *m*, except that iff `identical(`*o1*`, `*o2*`)` then *o1#m == o2#m*.

The closurization of setter *m* on object *o* is defined to be equivalent to `(a){return u.m = a; }` if *f* is named *m*, except that iff `identical(`*o1*`, `*o2*`)`  then *o1#m == o2#m*.


*There is no guarantee that `identical(`*o1.m*`, `*o2.m*`)`. Dart implementations are not required to canonicalize these or any other closures.*

**The special treatment of equality in this case facilitates the use of extracted property functions in APIs where callbacks such as event listeners must often be registered and later unregistered. A common example is the DOM API in web browsers.**

*Observations:*

*One cannot closurize a constructor, getter or a setter via the dot based syntax. One must use the # based form.
One can tell whether one implemented a property via a method or via a field/getter, which means that one has to plan ahead as to what construct to use, and that choice is reflected in the interface of the class.*

	
### 16.18.8 Named Constructor Closurization 

The *closurization of constructor f of type T* is defined to be equivalent to:


* `(r1,...,rn,{p1 : d1,...,pk : dk}){return new T.m(r1, ..., rn, p1 : p1, ..., pk : pk);  }`cif *f* is a named constructor with name *m* that has required parameters *r1, . . . , rn*, and named parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

* `(r1,...,rn,[p1 : d1,...,pk : dk]){ return new T.m(r1, ..., rn, p1, ..., pk);` if *f* is a named constructor with name *m* that has required parameters *r1, . . . , rn*, and optional positional parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

Except that iff `identical(`*T1*`, `*T2*`)` then **new** *T1#m ==* **new** *T2#m*.

*The above implies that for non-parameterized types, one can rely on the equality of closures resulting from closurization on the “same” type. For parameterized types, one cannot, since there is no requirement to canonicalize them.*


### 16.18.9 Anonymous Constructor Closurization 

The *closurization of anonymous constructor m on type T* is defined to be equivalent to:				

* `(r1,...,rn,{p1 : d1,...,pk : dk}){return new T(r1, ..., rn, p1 : p1, ..., pk : pk);  }` if m is an anonymous constructor that has required parameters *r1, . . . , rn*, and named parameters *p1, . . . , pk* with defaults d1, . . . , dk.

* `(r1,...,rn,[p1 : d1,...,pk : dk]){ return new T(r1, ..., rn, p1, ..., pk);}` if *m* is an anonymous constructor that has required parameters *r1, . . . , rn*, and optional positional parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

Except that iff `identical(`*T1*`, `*T2*`)` then **new** *T1# ==* **new** *T2#*.



	
### 16.18.10 Super Closurization	 			 					

The *closurization of method f with respect to superclass S* is defined to be equivalent to:

* `(a){return super m a;}` if *f* is named *m* and *m* is one of  `<,>,<=,>=,==,-,+, ̃/,/,*,%,|,ˆ,&,<<,>>,[]`.

* `(){return ~super;}` if *f* is named `~`.

* `(a, b){return super [a] = b;}` if *f* is named `[]=`.

* `(r1, ..., rn,{p1 : d1,...,pk : dk}){return super.m(r1, ..., rn, p1 : p1, ..., pk : pk);  }` if *f* is named *m* and has required parameters *r1, . . . , rn*, and named parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

* `(r1, ..., rn,[p1 : d1,...,pk : dk]){ return super.m(r1, ..., rn, p1, ..., pk);}`
if *f* is named *m* and has required parameters *r1, . . . , rn*, and optional positional parameters *p1, . . . , pk* with defaults *d1, . . . , dk*.

Except that iff  two closurizations were created by code declared in the same class with identical bindings of this then *super1#m == super2#m*,  *super1.m == super2.m*, *super1#m == super2.m* and *super1.m == super2#m*.

The closurization of getter f with respect to superclass *S* is defined to be equivalent to `(){return super.m; }` if *f* is named *m*, except that iff two closurizations were created by code declared in the same class with identical bindings of this then *super1#m == super2#m*.

The closurization of setter *f* with respect to superclass *S* is defined to be equivalent to `(a){return super.m = a; }` if *f* is named *m*, except that iff two closurizations were created by code declared in the same class with identical bindings of this then *super1#m == super2#m*. 
	
					



### 16.30 Postfix Expressions 

Postfix expressions invoke the postfix operators on objects.
```
postfixExpression:
      assignableExpression postfixOperator
    | primary (selector* | (‘#’  (( identifier ‘=’?) | operator)))
    ;

postfixOperator:
      incrementOperator
    ;


selector:
      assignableSelector
    | arguments
    ;

incrementOperator:
      '++'
    | '--'
    ;
```


A postfix expression is either a primary expression, a function, method or getter invocation, or an invocation of a postfix operator on an expression e.

A postfix expression of the form *v++*, where *v* is an identifier, is equivalent to `(){var r = v; v = r + 1; return r}()`.

**The above ensures that if *v* is a field, the getter gets called exactly once. Likewise in the cases below.** 

A postfix expression of the form *C.v ++* is equivalent to `(){var r = C.v; C.v = r + 1; return r}()`.

A postfix expression of the form *e1.v++* is equivalent to `(x){var r = x.v; x.v = r + 1; return r}(e1)`.

A postfix expression of the form *e1`[`e2`]`++* is equivalent to `(a, i){var r = a[i]; a[i] = r + 1; return r}(e1, e2)`

A postfix expression of the form *v--*, where *v* is an identifier, is equivalent to `(){var r = v; v = r - 1; return r}()`.

A postfix expression of the form *C.v--* is equivalent to `(){var r = C.v; C.v = r - 1; return r}()`.

A postfix expression of the form *e1.v--* is equivalent to `(x){var r = x.v; x.v = r - 1; return r}(e1)`.



### A working implementation

TBD

### Tests

TBD

## Patents rights

TC52, the Ecma technical committee working on evolving the open [Dart standard][], operates under a royalty-free patent policy, [RFPP][] (PDF). This means if the proposal graduates to being sent to TC52, you will have to sign the Ecma TC52 [external contributer form]() and submit it to Ecma.

[tex]: http://www.latex-project.org/
[language spec]: https://www.dartlang.org/docs/spec/
[dart standard]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[rfpp]: http://www.ecma-international.org/memento/TC52%20policy/Ecma%20Experimental%20TC52%20Royalty-Free%20Patent%20Policy.pdf
[external contributer form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf