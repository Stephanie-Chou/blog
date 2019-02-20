---
layout: post
title: "Using Functional Stateless React Components"
date: 2019-02-20
---

# Our Existing Pattern

The main issue I want to tackle is that we have components that are handling a lot of different pieces of logic and rendering. Some of these components are getting too big and doing too much in one place. I am proposing two things

1. We break up these components in to smaller pieces. We should break out the renderSubComponent() and write them as components.

2. We use Stateless Functional Components to achieve step 1. Personally, I like the syntax but am open to thoughts about just making everything a class.


The pattern that we see in most of our EmployeeSelfServiceClient code is as follows

```
export class Farm extends React.Component {
    constructor(props:) {
        super(props);
    }
    render() {
        return (<div>renderBarn()</div>);
    }

    private renderBarn() {
        if this.props.barnAge > 50 return <noscript />
        return (
            <div>
                <div> renderCow() </div>
                <div> renderHorse() </div>
            </div>
        );
    }

    private renderCow() {
        return (
            <div> {this.props.cowSound} </div>
        );
    }

    private renderHorse() {
        if (this.canRace()) {
            return (<h1> {this.props.horseSound} <h1>);
        }

        return (
            <div> {this.props.horseSound} </div>
        )
    }

    private canRace() {
        return this.props.horseAge < 2;
    }
}
```

There are a couple things to notice about the structure of the Farm Component:

* It is Stateless
* It has 4 different render functions.
* Not all of Farm's private functions actually get used for Farm- but rather for other subcomponents of Farm

Farm would be a great candidate to refactor and break the components out!

# Stateless Functional components

## What are they?

[[Stateless Functional Components>>https://itnext.io/react-component-class-vs-stateless-component-e3797c7d23ab]] are components that do not have state and are written as plain javascript functions that return JSX.  


Let's try applying this to our example code. We can start by rewriting renderBarn, renderCow, renderHorse so they become:

```
const Cow = (props) => {
    const { sound } = this.props;
    return (
        <div> {sound} </div>
    );
}

const Horse = (props) => {
    const { age, canRace,  sound } = this.props;

    if (canRace(age)) {
        return (<h1> {sound} <h1>);
    }

    return (
        <div> {sound} </div>
    )
}

const Barn = (props) => {
    if props.barnAge > 50 return <noscript />
    return (
        <div>
            <Cow sound={props.cowSound} />
            <Horse
                   sound={props.horseSound}
                   age={props.horseAge}
                   canRace={props.canRace}
                />
        </div>
    )
}
```

## Why would we want to break out these components?

One of the core patterns of React is [[composition>>https://reactjs.org/docs/composition-vs-inheritance.html]]. We used to have a Farm with 3 separate renders for Barn, Cow, and Horse. We now have a Farm that is composed of proper React components. Now we have a Farm that is composed of a Barn Component. The Barn is composed of a Cow and a Horse component. 

This leaves Farm simplified to: 

```
export class Farm extends React.Component {
    constructor(props:) {
     super(props);

     this.canRace = this.canRace.bind(this);
 }
     render() {
         const {barnAge, cowSound, horseSound, horseAge } =    this.props;
         return (<Barn
 
             cowSound={cowSound}
             horseSound={horseSound}
             horseAge={horseAge }
             canRace={ this.canRace }
         />);
     }
     private canRace(age) {
         return age <2;
     }
}

// Put Barn Horse and Cow functions down here
```
## So what's the difference?

You could argue: So what? these components are functionally the same as the render functions and none of these components we've created are being reused anywhere else.

We now have an easier opportunity to refactor. Let's say Farm get's really really big- it gets 3 more cows and 4 more horses. Now we have to add a Pasture and a Stable and put the Cows in the Pasture and Horses in the Stable. etc etc- this analogy is getting away from me. The point is- this Farm component would get away from you too. The Farm could easily blow up into a giant mega file that contains everything. It would become very hard to refactor.

But in this componentized format- we could easily pull out Horse, Cow and Barn into their own contained files.

## Do we really want to pull everything out into its own file?

Great question. Let's take it on a case by case basis starting with the Barn.

### Barn

It doesn't have it's own logic. It's okay broken out into it's own component- but maybe it doesn't need its own file. It only has display logic.

### Cow

It also does not have any particular logic, it is just display logic. we'll leave it here.

### Horse

It has its own little helper method. This is probably worth putting in to its own place. Let's separate our concerns- farm doesn't need to know about a Horse's racing ability.


```
/* Farm.jsx */
import { Horse } from "./Horse.jsx"; 

export const Farm = (props) => {
    const { barnAge, cowSound, horseSound, horseAge } = this.props;
    return (
        <Barn
            barnAge={ barnAge }
            cowSound={cowSound}
            horseSound={horseSound}
            horseAge={horseAge }
        />
    );
}

const Barn = (props) => {
    const { barnAge, cowSound, horseSound, horseAge } = this.props;

    if barnAge > 50 return <noscript />
    return (
        <div>
            <Cow sound={cowSound} />
            <Horse
               sound={horseSound}
               age={horseAge}
               canRace={canRace}
            />
        </div>
    )
}

const Cow = (props) => {
    const { sound } = this.props;
    return (
        <div> {sound} </div>
    );
}

/* Horse.jsx */

function canRace(age) {
    return age < 2;
}

export const Horse = (props) => {
    const { age, sound } = this.props;

    if (canRace(age)) {
        return (<h1> {sound} <h1>);
    }

    return (
        <div> {sound} </div>
    )
}
```

# Testing


By writing separated components, we can write better more granular tests that precisely describe what we want to test. Tests will be more readable. Tests will cover smaller subcomponents without extra noise from the parent components. Test coverage will go up.

### Testing Farm

Let's revisit the original Farm component. Testing the Farm and even Barn components would be pretty straightforward.

```
describe("Test Farm", () => {
    it("renders farm", () => {
        const wrapper = shallow(
            <Farm
                barnAge={2}
                cowSound="moo"
                horseSound="neigh"
                horseAge="1"
            />
        );
        expect(wrapper.find(Farm)).toHaveLength(1);
    }
});

describe("Test Barn", () => {
    it("renders Barn if barn younger than 50", () => {
        const wrapper = shallow(
            <Farm
                barnAge={2}
                cowSound="moo"
                horseSound="neigh"
                horseAge="1"
            />
        );
        expect(wrapper.find(Barn)).toHaveLength(1);
    }

    it("does not render barn if barn older than 50", () => {
        const wrapper = shallow(
            <Farm
                barnAge={60}
                cowSound="moo"
                horseSound="neigh"
                horseAge="1"
            />
        );
        expect(wrapper.find(Barn)).toHaveLength(0);
    })
});

```

### Testing Horse

But things get a little more complicated when we want to test Horse

In this scenario- we are depending on the fact that we have set up a test that properly passes props down from Farm through Barn to Horse. This Farm scenario is fairly simple and we are just passing props down. However, Barn had additional logic to hide or show Horse and Cow based on the barn's age. When we write tests for Horse and Cow, we have to account for these scenarios happening in Barn in order to properly test Horse.

```
describe("Test Horse", () => {
    it("renders Horse", () => {
        // We MUST render farm in order to test Horse
        // We MUST pick the right barn age
        const wrapper = shallow(
        <Farm
            barnAge={2}
            cowSound="moo"
            horseSound="neigh"
            horseAge={1}
        />);
        expect(wrapper.find(Horse)).toHaveLength(1);
    }

    it("can race if age less than 2", () => {
        const wrapper = shallow(
        <Farm
            barnAge={2}
            cowSound="moo"
            horseSound="neigh"
            horseAge={1}
        />);
        expect(wrapper.find('Horse').props.canRace).toBe(true);
    })

    it("cannot race if age greater than or equal 2", () => {
        const wrapper = shallow(
        <Farm
            barnAge={2}
            cowSound="moo"
            horseSound="neigh"
            horseAge={2}
        />);
        expect(wrapper.find('Horse').props.canRace).toBe(false);
    })
});

```

It is simpler to test:

* Given inputs for Farm, Farm passes expected props to Barn
* Given inputs for Barn, Barn passes expected props to Cow and Horse
* Given inputs for Horse, we are guaranteed a certain behavior.

Here's what tests Horse looks like if Horse is it's own component

```
describe("Test Horse", () => {
    it("can race if age less than 2", () => {
        const wrapper = shallow(
            <Horse
                horseSound="neigh"
                horseAge={2}
            />
        );

        expect(wrapper.find('Horse').props.canRace).toBe(true);
    });
});

```

# TLDR;

* Stateless Functional Components are javascript functions that return React components which have no state.
* Breaking out components help us write components which are composed of other react component
* Breaking out components enable us to separate concerns- 1 component class does not hold all the logic in its private functions
* Breaking out components enable simpler refactoring of code
* Breaking out components enable readability in tests and will help us increase our test coverage

### More Reading

[[https:~~/~~/hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc>>url:https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc]] (also links to why we shouldn't use them!)
