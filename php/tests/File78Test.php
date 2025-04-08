<?php
use PHPUnit\Framework\TestCase;
use Demo\File78;

class File78Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File78::add(2, 3));
    }
}
