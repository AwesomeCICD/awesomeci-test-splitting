<?php
use PHPUnit\Framework\TestCase;
use Demo\File56;

class File56Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File56::add(2, 3));
    }
}
