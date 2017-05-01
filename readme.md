Eric T Cormack<br />
CSC 491: iOS Development for Mobile Applications II<br />
Assignment 2<br />
30 April 2017

## Design
The user interacts with a simple stack of view controllers managed by a
navigation controller.

The first view controller is the `RouteTableViewController`. This makes a call
to the CTA's Bus Tracker app to populate itself with the routes of the CTA
busses. It creates `Route`s from the supplied data and displays them in a table
view.

When a `RouteTableViewCell` is selected, it passes the `Route` contained therein
to the `DirectionViewController`. This controller takes this data, and makes
another call to the Bus Tracker to see which directions this route is traveled.
With this information, formatted into a `Direction` enum, the controller
displays two options for the user: "Northbound" and "Southbound" arranged on the
top and bottom halves of the screen or "Eastbound" and "Westbound" arranged on
the right and left sides of the screen.

When one of these options is selected, the 'DirectionViewController' passes the
`Direction` and `Route` information to the `StopViewController`. A call is then
made with the Route and Direction data to collect the stops serviced on the
route. Xbound and Ybound stops at an intersection are actually considered
separate stops for this service, and so the direction must be specified when
requesting the data. This stop data, including longitude and latitude, are
stored in the `BusStop` class. The `StopViewController` then displays these
stops, alphabetically (that is the data is sent alphabetically). When one of
these are selected this view controller passes the stop, route and direction
data to the `TimeViewController`.

Here, two calls are made to the API: one for the upcoming busses for the given
stop (route agnostic) and one for the alerts for this direction on the chosen
route. These are sorted into the `Prediction` and `Warning` classes
respectively. The former are sorted explicitly by time (it prevent any
hiccoughs from the API) and the latter are split into two arrays, one for the
high priority alerts, and one for the rest. The first element of the arrival
times is set as the main display on top. Below is a table view, the high
priority alerts are listed first, then the next bus times, and finally the
medium and low priority warnings.

## Error Handling
For the most part, while building this program, I ensured that the data
contained in the requests were well formed and contained the information that
was requested. The singleton `CTAConnector`'s `makeRequest` call specifically
tosses out any erroneous returns and responses that do not come with the HTTP
code 200. There is an option to let the caller of `makeRequest` supply a
`() -> Void` closure to provide some means of gracefully failing. But I have
found that I had not particularly needed it for this project. A failure closure
is supplied for the `DirectionViewController`'s case to pop back to the main
screen should a failure occur.

Additionally, I've made the request from `TimeViewController` handle data that
doesn't have the expected information, as there are times when there is no
data supplied (*e.g.* a route is currently not in service). Normally these
would make make the code fail, and so there is an additional check to see if
there just isn't data supplied from the server (there are specific JSON messages
for when this is the case).

I suppose I could introduce code to reattempt a call to the service should the
route and stop lists error out.

## Circular references
I feel that I did not particularly need to watch out for this. The model do not
refer to each other, and my view and controller classes only have weak
references to each other.

## Extras
I built unit tests for the large majority of my code, some of which took much
more time debugging than the code itself. Where my code is lacking, is where I
could not figure out how to keep the data loaded in the tableview classes (I
kept getting default values for labels even though the program was loading the
data fine), and for the `TimeViewController` (the data needed for this is so
volatile that I feared that the tests might fail just because the service is
performing correctly).
