#Less Restricted Mixins

## Contact information

1. **Gilad Bracha.** 

2. **gbracha@google.com.** 

3. **https://github.com/gbracha/lessRestrictedMixins** 



##Summary 

We propose to remove the some of restrictions on mixins currently in Dart. Specifically

* Mixins can refer to super.
* Mixins can have superclasses other than Object.

When a mixin is applied, the resulting type is a subtype of the mixin type, as it is today. However, if the resulting type would not otherwise be a subtype of the declared supertypes of the mixin, a warning is issued. Hence, a mixin application would have to declare, directly or indirectly, that itssuperclass implements the mixin's superclass, and that it implements the mixin's superinterfaces in order to be warning-free.


##Motivation

Ad hoc restrictions are a sign of bad design. The above restrictions were always intended to be temporary. They were not part of the original 
design, which proposed a semantics that fully supported all of the restricted features. This should be motivation enough. 

For the more pragmatic, users have repeatedly complained about the restrictions, which prevent the use of mixins in many situations where they might otherwise be helpful.


See bugs 
https://code.google.com/p/dart/issues/detail?id=12905
https://code.google.com/p/dart/issues/detail?id=12456

##Pros

* The language is more expressive and cleaner
* This proposal avoids the complexity associated with adding constructors to mixins

##Cons

* No support for mixins with (non-trivial) constructors.

##Examples


Example 1 (due to Jacob McDonald)

In Polymer 0.9 there is the notion of Behaviors of elements:

A behavior can define lifecycle callbacks, declared properties, default attributes, observers, listeners.

Almost all of these features could be handled today by mixins (although the semantics would be slightly different), with the exception of the lifecycle callbacks. These callbacks need to get invoked on each behavior, in the reverse order they they were mixed in. If mixins could do super calls, then this could potentially work out of the box:

```
class FooBehavior extends Behavior {
  void ready() {
    super.ready();
    print('FooBehavior ready');
  }
}

class BarBehavior extends Behavior {
  void ready() {
    super.ready();
    print('BarBehavior ready');
  }
}

class PolymerElement {
  void ready() {
    print('PolymerElement ready');
  };
}

class MyElement extends PolymerElement with FooBehavior, BarBehavior implements Behavior {
  void ready() {
    print('MyElement ready');
    super.ready(); // Call super at the end to emulate the polymer js semantics.
  }
}
```

When the `ready` method is invoked on `MyElement`, this will print:

MyElement ready

PolymerElement ready

FooBehavior ready

BarBehavior ready

In this case, none of the constructors along the superclass chain take parameters, which simplifies matters considerably. 



##Semantics

As noted, only one of the existing three restrictions on classes used as mixins is retained: the class cannot have a non-trivial constructor. This in turn implies that its superclass must have a trivial constructor.

A mixin application is treated as a subtype of the class whose mixin is being applied. Warnings are given if this would not in fact be the case. Specifically, if the mixin is applied to a superclass that is not a subtype of the superclass of original class, a warning issued. This gives notice that the mixin application itself may not provide all the expected interface of the mixin, since some inherited members might be missing.

The existing specification will ensure that a warning is given if **super** calls in the code may fail, as they will be bound to the actual superclass which may be lacking expected members. Likewise, if any superinterfaces of the mixin are not properly supported, a warning will be given under existing rules.

The ability to use **super** in a mixin implies that **super** calls are no longer statically bound to the superclass of the class in which they appear. The actual superclass the call will bind to is the class to which the mixin is applied. This can be implemented in different ways - either by dynamic binding or by copying modified versions of the containing method to the mixin application.

The semantics are described by the specification changes below.

We revise section 12 of the specification to remove the restrictions on superclasses and the use of **super**. This includes changes to the body of section 12, and appending some text to section 12.1.

The text for **super** invocation needs to be slightly revised so it is clear that the call is late bound (at least conceptually) to the next mixin application up the inheritance chain. This occurs in sections 16.17.3, 16.18.2, 16.18.6, 16.19. In all cases, one has to distinguish between S<sub>static</sub>, the superclass of the enclosing class, and S<sub>dynamic</sub>, the superclass of the mixin application executing at the point of the call.

In support of the above, a slight change in the wording of 16.15.1 and 16.15.2 is required. The changed is highlighted in **bold**.




##12 Mixins

A mixin describes the difference between a class and its superclass. A mixin is always derived from an existing class declaration.

~~It is a compile-time error if a declared or derived mixin refers to super.~~ It is a compile-time error if a declared or derived mixin explicitly declares a constructor. ~~It is a compile-time error if a mixin is derived from a class whose superclass is not Object.~~

This restrictions is temporary. We expect to remove it in later versions of Dart.
~~The restriction on the use of super avoids the problem of rebinding super when the mixin is bound to difference superclasses.~~

The restriction on constructors simplifies the construction of mixin applications because the process of creating instances is simpler.
~~The restriction on the superclass means that the type of a class from which a mixin is derived is always implemented by any class that mixes it in. This allows us to defer the question of whether and how to express the type of the mixin independently of its superclass and super interface types.
Reasonable answers exist for all these issues, but their implementation is non-trivial.~~


### **12.1 Mixin Application**

Let *M<sub>A</sub>* be a mixin derived from a class *M* with direct superclass *S*. 

Let *A* be an application of *M<sub>A</sub>*. It is a static warning if the superclass of *A* is not a subtype of *S*.

Let *C* be a class declaration  that includes *M<sub>A</sub>* in a **with** clause. It is a static warning if *C* does not implement, directly or indirectly, all the direct superinterfaces of *M*. 


## 16.15.1 Method Lookup

The result of a lookup of a method *m* in object *o* with respect to library *L* is the result of a lookup of method *m* in class *C* with respect to library *L*, where *C* is the class of *o*.

The result of a lookup of method *m* in class *C* with respect to library *L* is: If *C* declares a concrete instance method named *m* that is accessible to *L*, then that method is the result of the lookup**, and we say that the method was *looked up in C*.** Otherwise, if *C* has a superclass *S*, then the result of the lookup is the result of looking up *m* in *S* with respect to *L*. Otherwise, we say that the method lookup has failed.

*The motivation for skipping abstract members during lookup is largely to allow smoother mixin composition.*


## 16.15.2 Getter and Setter Lookup

The result of a lookup of a getter (respectively setter) *m* in object *o* with respect to library *L* is the result of looking up getter (respectively setter) *m* in class *C* with respect to *L*, where *C* is the class of *o*.

The result of a lookup of a getter (respectively setter) *m* in class *C* with respect to library *L* is: If *C* declares a concrete instance getter (respectively setter) named *m* that is accessible to *L*, then that getter (respectively setter) is the result of the lookup**, and we say that the getter was *looked up in C*.** Otherwise, if *C* has a superclass *S*, then the result of the lookup is the result of looking up getter (respectively setter) *m* in *S* with respect to *L*. Otherwise, we say that the lookup has failed.

*The motivation for skipping abstract members during lookup is largely to allow smoother mixin composition.*



## 16.17.3 Super Invocation

A super method invocation *i* has the form *super.m(a<sub>1</sub>,...,a<sub>n</sub>,x<sub>n+1</sub> : a<sub>n+1</sub>,...,x<sub>n+k</sub> : a<sub>n+k</sub>)*.
Evaluation of *i* proceeds as follows:

First, the argument list *(a<sub>1</sub>,...,a<sub>n</sub>,x<sub>n+1</sub> : a<sub>n+1</sub>,...,x<sub>n+k</sub> : a<sub>n+k</sub>)* is evaluated yielding actual argument objects *o<sub>1</sub>*, . . . , *o<sub>n+k</sub>*. Let *g* be the method currently executing, and let *C* be the class in which *g* was looked up. Let *S<sub>dynamic</sub>* be the superclass of *C* ~~the immediately enclosing class~~, and let *f* be the result of looking up method (16.15.1) *m* in *S<sub>dynamic</sub>* with respect to the current library *L*.Let *p<sub>1</sub> . . . p<sub>h</sub>* be the required parameters of *f* , let *p<sub>1</sub> . . . p<sub>m</sub>* be the positional parameters of *f* and let *p<sub>h+1</sub>, . . . , p<sub>h+l</sub>* be the optional parameters declared by *f*.

If *n < h*, or *n > m*, the method lookup has failed. Furthermore, each *x<sub>i</sub>, n + 1 ≤ i ≤ n + k*
, must have a corresponding named parameter in the set *{p<sub>m+1</sub>, . . . , p<sub>h+l</sub>}* or the method lookup also fails. Otherwise method lookup has succeeded.

If the method lookup succeeded, the body of *f* is executed with respect to the bindings that resulted from the evaluation of the argument list, and with this bound to the current value of this. The value of *i* is the value returned after *f* is executed.

If the method lookup has failed, then let *g* be the result of looking up getter (16.15.2) *m* in *S<sub>dynamic</sub>* with respect to *L*. If the getter lookup succeeded, let *v<sub>g</sub>* be the value of the getter invocation **super***.m*. Then the value of *i* is the result of invoking the static method Function.apply() with arguments *v.g,[o<sub>1</sub>,...,o<sub>n</sub>],{x<sub>n+1</sub> : o<sub>n+1</sub>,...,x<sub>n+k</sub> : o<sub>n+k</sub>}*.

If getter lookup has also failed, then a new instance *im* of the predefined class Invocation is created, such that :

+ im.isMethod evaluates to true.

+ im.memberName evaluates to the symbol *m*.

+ im.positionalArguments evaluates to an immutable list with the same values as *[o<sub>1</sub>,...,o<sub>n</sub>]*.

+ im.namedArguments evaluates to an immutable map with the same keys and values as *{x<sub>n+1</sub> : o<sub>n+1</sub>, . . . , x<sub>n+k</sub> : o<sub>n+k</sub>}*.

Then the method noSuchMethod() is looked up in *S<sub>dynamic</sub>* and invoked on **this** with argument *im*, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of noSuchMethod() in class Object is invoked on this with argument *im′*, where *im′* is an instance of Invocation such that :

+ im’.isMethod evaluates to **true**.

+ im’.memberName evaluates to #noSuchMethod.

+ im’.positionalArguments evaluates to an immutable list whose sole element is *im*.

+ im’.namedArguments evaluates to the value of **const** {}.

and the result of this latter invocation is the result of evaluating *i*.
It is a compile-time error if a super method invocation occurs in a top-level function or variable initializer, in an instance variable initializer or initializer list, in class Object, in a factory constructor or in a static method or variable
initializer.

Let *S<sub>static</sub>* be the superclass of the immediately enclosing class. It is a static type warning if *S<sub>static</sub>* does not have an accessible (6.2) instance
member named *m* unless *S<sub>static</sub>* or a superinterface of *S<sub>static</sub>* is annotated with an annotation denoting a constant identical to the constant @proxy defined in dart:core. If *S<sub>static</sub>.m* exists, it is a static type warning if the type *F* of *S<sub>static</sub>.m* may not be assigned to a function type. If *S<sub>static</sub>.m* does not exist, or if *F* is not a function type, the static type of *i* is dynamic; otherwise the static type of *i* is the declared return type of *F*.



##16.18.2 Super Getter Access and Method Closurization

Evaluation of a property extraction *i* of the form super.m proceeds as follows:

Let *g* be the method currently executing, and let *C* be the class in which *g* was looked up. Let *S<sub>dynamic</sub>* be the superclass of *C*
~~Let *S* be the superclass of the immediately enclosing class~~. Let *f* be the result of looking up method *m* in *S<sub>dynamic</sub>* with respect to the current library *L*. If method lookup succeeds then *i* evaluates to the closurization of method *f* with respect to superclass *S<sub>dynamic</sub>* (16.18.10).

Otherwise, *i* is a getter invocation. Let *f* be the result of looking up getter *m* in *S<sub>dynamic</sub>* with respect to *L*. The body of *f* is executed with this bound to the current value of **this**. The value of *i* is the result returned by the call to the getter function.

If the getter lookup has failed, then a new instance *im* of the predefined class Invocation is created, such that :

+ im.isGetter evaluates to **true**.

+ im.memberName evaluates to the symbol *m*.

+ im.positionalArguments evaluates to the value of **const** []. 

+ im.namedArguments evaluates to the value of **const** {}.


Then the method noSuchMethod() is looked up in *S<sub>dynamic</sub>* and invoked with argument *im*, and the result of this invocation is the result of evaluating *i*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of noSuchMethod() in class Object is invoked on this with argument *im′*, where *im′* is an instance of Invocation such that :

+ im’.isMethod evaluates to **true**.

+ im’.memberName evaluates to #noSuchMethod.

+ im’.positionalArguments evaluates to an immutable list whose sole element is *im*.

+ im’.namedArguments evaluates to the value of **const** {}.

and the result of this latter invocation is the result of evaluating *i*.



Let *S<sub>static</sub>* be the superclass of the immediately enclosing class. 

It is a static type warning if *S<sub>static</sub>* does not have an accessible instance method
or getter named *m*.

The static type of *i* is:

+ The declared return type of *S<sub>static</sub>.m*, if *S<sub>static</sub>* has an accessible instance getter named *m*.

+ The static type of function *S<sub>static</sub>.m* if *S<sub>static</sub>* has an accessible instance method
named *m*.

+ The type **dynamic** otherwise.


##16.18.6 General Super Property Extraction

Evaluation of a property extraction *i* of the form super#m proceeds as follows:

Let *g* be the method currently executing, and let *C* be the class in which *g* was looked up. Let *S<sub>dynamic</sub>* be the superclass of *C*
~~Let *S* be the superclass of the immediately enclosing class.~~

If *m* is a setter name, let *f* be the result of looking up setter *m* in *S<sub>dynamic</sub>* with respect to the current library *L*. If setter lookup succeeds then *i* evaluates to the closurization of setter *f* with respect to superclass *S<sub>dynamic</sub>* (16.18.10). If setter lookup failed, a NoSuchMethodError is thrown.

If *m* is not a setter name, let *f* be the result of looking up method *m* in *S<sub>dynamic</sub>* with respect to the current library *L*. If method lookup succeeds then *i* evaluates to the closurization of method *m* with respect to superclass *S<sub>dynamic</sub>* (16.18.10).

Otherwise, let *f* be the result of looking up getter *m* in *S<sub>dynamic</sub>* with respect to the current library *L*. If getter lookup succeeds then *i* evaluates to the closurization of getter *f* with respect to superclass *S<sub>dynamic</sub>* (16.18.10). If getter lookup failed, a NoSuchMethodError is thrown.

Let *S<sub>static</sub>* be the superclass of the immediately enclosing class. 

It is a static type warning if *S<sub>static</sub>* does not have an accessible instance member named *m*.

The static type of *i* is the static type of the function *S<sub>static</sub>.m*, if *S<sub>static</sub>* has an accessible instance member named *m*. Otherwise the static type of *i* is **dynamic**.


We also modify one section of 16.19

## 16.19 Assignment




Evaluation of an assignment of the form super.v = e proceeds as follows:

Let *g* be the method currently executing, and let *C* be the class in which *g* was looked up. Let *S<sub>dynamic</sub>* be the superclass of *C*
~~Let S be the superclass of the immediately enclosing class~~. The expression *e* is evaluated to an object *o*. Then, the setter *v=* is looked up (16.15.2) in *S<sub>dynamic</sub>*
with respect to the current library. The body of *v=* is executed with its formal parameter bound to o and this bound to **this**.

If the setter lookup has failed, then a new instance *im* of the predefined class Invocation is created, such that :

+ im.isSetter evaluates to **true**.

+ im.memberName evaluates to the symbol *v=*.

+ im.positionalArguments evaluates to an immutable list with the same values as *[o]*.

+ im.namedArguments evaluates to the value of **const** {}.

Then the method noSuchMethod() is looked up in *S<sub>dynamic</sub>* and invoked with argument *im*. However, if the implementation found cannot be invoked with a single positional argument, the implementation of noSuchMethod() in class Object is invoked on **this** with argument *im′*, where *im′* is an instance of Invocation such that :

+ im’.isMethod evaluates to true.

+ im’.memberName evaluates to #noSuchMethod.

+ im’.positionalArguments evaluates to an immutable list whose sole element is *im*.

+ im’.namedArguments evaluates to the value of **const** {}.


The value of the assignment expression is *o* irrespective of whether setter lookup has failed or succeeded.

Let *S<sub>static</sub>* be the superclass of the immediately enclosing class. 

In checked mode, it is a dynamic type error if *o* is not null and the interface of the class of *o* is not a subtype of the actual type of *S<sub>static</sub>.v*.

It is a static type warning if *S<sub>static</sub>* does not have an accessible instance setter named *v=* unless *S<sub>static</sub>* or a superinterface of *S<sub>static</sub>* is annotated with an annotation denoting a constant identical to the constant @proxy defined in dart:core.

It is a static type warning if the static type of *e* may not be assigned to the static type of the formal parameter of the setter *v=*. The static type of the expression **super***.v = e* is the static type of *e*.

##A Working Implementation

TBD

##Tests

See example 1.

TBD

##Patents Rights

TC52, the Ecma technical committee working on evolving the open [Dart standard][], operates under a royalty-free patent policy, [RFPP][] (PDF). This means if the proposal graduates to being sent to TC52, you will have to sign the Ecma TC52 [external contributer form]() and submit it to Ecma.

[tex]: http://www.latex-project.org/
[language spec]: https://www.dartlang.org/docs/spec/
[dart standard]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[rfpp]: http://www.ecma-international.org/memento/TC52%20policy/Ecma%20Experimental%20TC52%20Royalty-Free%20Patent%20Policy.pdf
[external contributer form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf

